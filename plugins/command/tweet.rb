module Flumtter
  class Command
    class Tweet < Base
      Screen = [
        "【Tweet Screen】",
        "Please input tweet content.",
        "Syntax: '\#{content}'"
      ]
      Error = [
        "【ERROR】",
        "Please input one or more word."
      ]

      def initialize(twitter, text)
        super(text, Screen)
        unless @input.size.zero?
          twitter.rest.update @input
        else
          Curses.window Error
        end
      end
    end
    
    Help.add "n:New tweet"

    new do |input, twitter|
      case input
      when /^(n|N|ｎ|Ｎ)(\s*|　*)(.*)/
        Tweet.new twitter, $3
        true
      end
    end
  end
end