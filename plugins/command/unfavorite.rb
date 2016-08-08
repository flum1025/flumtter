module Flumtter
  class Command
    class UnFavorite < Base
      Screen = [
        "【UnFavorite Screen】",
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
            begin
              twitter.rest.unfavorite(object.id)
              print 'unfavorite success'.dnl.color(:cyan)
            rescue ::Twitter::Error::NotFound => ex
              if ex.message == "No status found with that ID."
                print 'not favorited'.dnl.color(:cyan)
              else
                raise ex
              end
            end
          else
            Curses.window ObjectError
          end
        else
          Curses.window SyntaxError
        end
      end
    end
    
    Help.add "l:UnFavorite"

    new do |input, twitter|
      case input
      when /^(l|L|l|L)(\s*|　*)(.*)/
        UnFavorite.new twitter, $3
        true
      end
    end
  end
end