module Flumtter
  class Command
    class DirectMessage < Base
      Screen = [
        "【DirectMessage screen】",
        "Please input target (index or screen_name) and DM content.",
        "Syntax: '\#{index|screen_name} \#{content}''"
      ]
      Error = [
        "【ERROR】",
        "Please input (Index or Screen_name) and message content."
      ]

      def initialize(twitter, text)
        super(text, Screen)
        case @input
        when /^(\d+)(\s*|　*)(.*)/
          object = TimeLineElement::Base[$1.to_i]
          case object
          when ::Twitter::DirectMessage
            unless $3.nil? || $3.size.zero?
              twitter.rest.create_direct_message(object.sender.id, $3)
            else
              Curses.window Error
            end
          when ::Twitter::Tweet
            unless $3.nil? || $3.size.zero?
              twitter.rest.create_direct_message(object.user.id, $3)
            else
              Curses.window Error
            end
          else
            Curses.window ObjectError
          end
        when /^((@|＠)[A-Za-z0-9_]{1,15})(\s*|　*)(.*)/
          unless $4.nil? || $4.size.zero?
            twitter.rest.create_direct_message($1, $4)
          else
            Curses.window Error
          end
        else
          Curses.window SyntaxError
        end
      end
    end

    Help.add "d:Direct message"

    new do |input, twitter|
      case input
      when /^(d|D|ｄ|Ｄ)(\s*|　*)(.*)/
        DirectMessage.new twitter, $3
        true
      end
    end
  end
end