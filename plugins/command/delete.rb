module Flumtter
  class Command
    class Delete < Base
      Screen = [
        "【Delete Screen】",
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
              twitter.rest.destroy_status(object.id)
            rescue ::Twitter::Error::Forbidden => ex
              if ex.message == "You may not delete another user's status."
                print ex.message.dnl.color(:cyan)
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
    
    Help.add "k:Delete"

    new do |input, twitter|
      case input
      when /^(k|K|ｋ|Ｋ)(\s*|　*)(.*)/
        Delete.new twitter, $3
        true
      end
    end
  end
end