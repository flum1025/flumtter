require 'oauth'
require 'oauth/consumer'
require 'twitter'
require_relative 'hash'

module Flumtter
  class Account
    attr_reader :id, :screen_name, :keys
    def initialize(options)
      raise ArgumentError, "Argument is not hash" unless options.is_a?(Hash)
      keys = %i(consumer_key consumer_secret access_token access_token_secret)
      options.requires(*%i(screen_name)+keys)
      @screen_name = options[:screen_name]
      @id = options[:id]
      @keys = Hash[keys.zip options.values_at(*keys)]
    end
  end

  class AccountSelector
    @@account_list = (Config[:accounts] ||= []).map{|a|Account.new(a)}

    class << self
      def select(options={})
        account = if options[:id]
          @@account_list[options[:id]]
        elsif options[:name]
          @@account_list.select{|a|a.screen_name == options[:name]}.first
        elsif @@account_list.empty?
          regist
          @@account_list.first
        else
          dialog = Dialog.new("Account Selector", <<~EOF)
            Please input your account number.
            Input 'regist' if you want to regist new account.

            #{@@account_list.map.with_index{|a,i|"#{i}: #{a.screen_name}"}.join("\n")}
          EOF
          dialog.command(/^regist$/, "account registration"){|m|regist}
          dialog.command(/^([#{@@account_list.size.times.to_a.join(",")}])$/, "account index"){|m|@@account_list[m[1].to_i]}
          dialog.show(true)
        end
        Client.new account
      end

      def regist
        dialog = Dialog.new("Register Twitter Account", <<~EOF, 6, 70)
          Please enter according to the screen.
        EOF
        keys = {}
        dialog.show do |win|
          Curses.echo
          win.setpos(win.cury+2, 1)
          win.addstr("consumer_key: ")
          keys[:consumer_key] = win.getstr
          win.setpos(win.cury, 1)
          win.addstr("consumer_secret: ")
          keys[:consumer_secret] = win.getstr
        end
        if keys[:consumer_key].empty? && !@@account_list.empty?
          keys[:consumer_key], keys[:consumer_secret] = 
            @@account_list.last.keys.values_at(%i(consumer_key consumer_secret))
        end

        consumer = OAuth::Consumer.new(keys[:consumer_key], keys[:consumer_secret], {:site=>"https://api.twitter.com"})
        request_token = consumer.get_request_token

        dialog = Dialog.new("Register Twitter Account", <<~EOF)
          Please access the following URL.
          And get the Pin code.

          #{request_token.authorize_url}

          Enter your Pin code: 
        EOF
        dialog.command(/(.+)/) do |m|
          access_token = request_token.get_access_token(:oauth_verifier => m[1])
          keys[:access_token] = access_token.token
          keys[:access_token_secret] = access_token.secret
          user = Twitter::REST::Client.new(keys).user
          keys[:id], keys[:screen_name] = user.id, user.screen_name
          Config[:accounts] << keys
          @@account_list = Config[:accounts].map{|a|Account.new(a)}
        end
        dialog.show(false, false)
        select
      end
    end
  end
end
