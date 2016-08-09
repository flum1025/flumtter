#unsupport
#module Flumtter
#  class Command
#    class UnRetweet < Base
#      Screen = [
#        "【UnRetweet Screen】",
#        "Please input target index.",
#        "Syntax: '\#{index}'"
#      ]
#
#      def initialize(twitter, text)
#        super(text, Screen)
#        case @input
#        when /^(\d+)/
#          object = TimeLineElement::Base[$1.to_i]
#          case object
#          when ::Twitter::Tweet
#            begin
#              twitter.rest.unretweet(object.id)
#              print 'unretweet success'.dnl.color(:cyan)
#            rescue => ex
#              raise ex
#            end
#          else
#            Curses.window ObjectError
#          end
#        else
#          Curses.window SyntaxError
#        end
#      end
#    end
#    
#    Help.add "j:UnRetweet"
#
#    new do |input, twitter|
#      case input
#      when /^(j|J|ｊ|Ｊ)(\s*|　*)(.*)/
#        UnRetweet.new twitter, $3
#        true
#      end
#    end
#  end
#end