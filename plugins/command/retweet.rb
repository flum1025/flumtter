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
            if object.retweeted?
              print 'already retweeted'.dnl.color(:cyan)
            else
              begin
                twitter.rest.retweet(object.id)
              rescue ::Twitter::Error::Forbidden => ex
                if ex.message == "You have already retweeted this tweet."
                  print 'already retweeted'.dnl.color(:cyan)
                else
                  raise ex
                end
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