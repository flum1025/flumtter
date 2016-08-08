module Flumtter
  class Command
    class Favorite < Base
      Screen = [
        "【Favorite Screen】",
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
            if object.favorited?
              print 'already favorited'.color(:cyan).dnl
            else
              twitter.rest.favorite(object.id)
            end
          else
            Curses.window ObjectError
          end
        else
          Curses.window SyntaxError
        end
      end
    end
    
    Help.add "f:Favorite"

    new do |input, twitter|
      case input
      when /^(f|F|ｆ|Ｆ)(\s*|　*)(.*)/
        Favorite.new twitter, $3
        true
      end
    end
  end
end