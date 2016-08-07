module Flumtter
  class Command
    class Pakuru < Base
      Screen = [
        "【Paku-ru screen】",
        "Please input target index.",
        "Syntax: '\#{index}'"
      ]
      Error = [
        "【ERROR】",
        "Please select Tweet number or Event number or DirectMessage number."
      ]

      def initialize(twitter, text)
        super(text, Screen)
        case @input
        when /^(\d+)/
          object = TimeLineElement::Base[$1.to_i]
          case object
          when ::Twitter::Tweet, ::Twitter::DirectMessage
            twitter.rest.update(object.text)
          else
            Curses.window Error
          end
        else
          Curses.window SyntaxError
        end
      end
    end
    
    Help.add "o:Paku-ru"

    new do |input, twitter|
      case input
      when /^(o|O|ｏ|Ｏ)(\s*|　*)(.*)/
        Pakuru.new twitter, $3
        true
      end
    end
  end
end