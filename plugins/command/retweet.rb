module Flumtter
  class Command
    class Retweet < Base
      Screen = [
        "【Retweet Screen】",
        "Please input target index.",
        "Syntax: '\#{index}'"
      ]

      def initialize(twitter, text)
        super(text, Screen)
        case @input
        when /^(\d+)/
          object = TimeLineElement::Base[$1.to_i]
          case object
          when ::Twitter::Tweet
            twitter.rest.retweet(object.id)
          else
            Curses.window ObjectError
          end
        else
          Curses.window SyntaxError
        end
      end
    end
    
    Help.add "t:Retweet"

    new do |input, twitter|
      case input
      when /^(t|T|ｔ|Ｔ)(\s*|　*)(.*)/
        Retweet.new twitter, $3
        true
      end
    end
  end
end