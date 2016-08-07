module Flumtter
  class Command
    class Reply < Base
      Screen = [
        "【Reply Screen】",
        "Please input target (index or screen_name) and tweet content.",
        "Syntax: '\#{index|screen_name} \#{content}'"
      ]

      def initialize(twitter, text)
        super(text, Screen)
        case @input
        when /^(\d+)(\s*|　*)(.*)/
          object = TimeLineElement::Base[$1.to_i]
          case object
          when ::Twitter::Tweet
            twitter.rest.update("@#{object.user.screen_name} #{$3}", :in_reply_to_status_id => object.id)
          when ::Twitter::DirectMessage
            DirectMessage.new twitter, @input
          else
            Curses.window ObjectError
          end
        when /^((@|＠)[A-Za-z0-9_]{1,15})(\s*|　*)(.*)/
          twitter.rest.update("#{$1} #{$4}")
        else
          Curses.window SyntaxError
        end
      end
    end
    
    Help.add "r:Reply"

    new do |input, twitter|
      case input
      when /^(r|R|ｒ|Ｒ)(\s*|　*)(.*)/
        Reply.new twitter, $3
        true
      end
    end
  end
end