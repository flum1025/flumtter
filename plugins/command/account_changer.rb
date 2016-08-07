module Flumtter
  class Command
    Help.add "a:Account change"

    new do |input, twitter|
      case input
      when /^(a|A|ａ|Ａ)(\s*|　*)(.*)/
        twitter.change AccountSelector.select
        twitter.stream
        true
      end
    end
  end

  module Setting
    class Account < Base
      Header = [
        "【Account Manager】",
        "Please select the account you want to delete.",
        "Input 'exit' if you want to back.",
        ""
      ]

      def initialize
        body = $userConfig[:save_data][:accounts].values.map.with_index{|account,index|"#{index}:#{account[:screen_name]}"}
        loop do
          input = Curses.window Header + body
          case input
          when /^(\d+)/
            unless $userConfig[:save_data][:accounts].keys[$1.to_i].nil?
              $userConfig[:save_data][:accounts].delete $userConfig[:save_data][:accounts].keys[$1.to_i]
              print "Delete account is success!".dnl.color(:cyan)
              break
            else
              Curses.window Curses::TextSet[:wrong_number]
            end
          when /exit/
            break
          else
            Curses.window Curses::TextSet[:command_not_found]
          end
        end
      end
    end

    Setting.add 'a:Account setting'

    Setting.new do |input, setting|
      case input
      when /^(a|A|ａ|Ａ)(\s*|　*)(.*)/
        Account.new
        true
      end
    end
  end
end