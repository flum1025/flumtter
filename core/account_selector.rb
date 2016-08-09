require 'oauth'
require 'oauth/consumer'

module Flumtter
  class AccountSelector
    TEXT = [
      "【Account Setting】",
      "Please input your account number.",
      "Input 'regist' if you want to regist new account."
    ]

    def self.select(ind=nil)
      $userConfig[:save_data][:accounts] ||= {}
      input = if !ind.nil?
        ind
      elsif $userConfig[:save_data][:accounts].size.zero?
        "regist"
      else
        Curses.window TEXT + $userConfig[:save_data][:accounts].values.map.with_index{|account,index|"#{index}:#{account[:screen_name]}"}
      end
      case input
      when /^(\d+)/
        unless $userConfig[:save_data][:accounts].keys[$1.to_i].nil?
          $userConfig[:save_data][:accounts][$userConfig[:save_data][:accounts].keys[$1.to_i]]
        else
          Curses.window Curses::TextSet[:wrong_number]
          self.select
        end
      when /regist/
        regist
        self.select
      when /@([0-9a-z_]{1,15})/i
        unless $userConfig[:save_data][:accounts][$1].nil?
          $userConfig[:save_data][:accounts][$1]
        else
          Curses.window Curses::TextSet[:wrong_number]
          self.select
        end
      else
        Curses.window Curses::TextSet[:command_not_found]
        self.select
      end
    end
    
    def self.regist
      print "Enter your consumer_key: "; consumer_key = STDIN.gets.chomp
      consumer_key = $userConfig[:save_data][:accounts].values.last[:consumer_key] if consumer_key.size.zero?
      print "Enter your consumer_secret: ";consumer_secret = STDIN.gets.chomp
      consumer_secret = $userConfig[:save_data][:accounts].values.last[:consumer_secret] if consumer_secret.size.zero?
      consumer = OAuth::Consumer.new(consumer_key ,consumer_secret,{:site=>"https://api.twitter.com"})
      request_token = consumer.get_request_token
      puts "Please access this URL: ","#{request_token.authorize_url}","and get the Pin code."
      print "Enter your Pin code: "
      access_token = request_token.get_access_token(:oauth_verifier => STDIN.gets.chomp)
      keys = {
        consumer_key: consumer_key,
        consumer_secret: consumer_secret,
        access_token: access_token.token,
        access_token_secret: access_token.secret
      }
      user = ::Twitter::REST::Client.new(keys).user
      [:id, :screen_name].map{|x| keys[x] = user.send(x)}
      $userConfig[:save_data][:accounts][keys[:screen_name]] = keys
    end
  end
end