require 'io/console'

module Flumtter
  class Command
    class Base
      ObjectError = [
        "【ERROR】",
        "Please select correct index."
      ]
      SyntaxError = [
        "【ERROR】",
        "Syntax Error"
      ]

      def initialize(text, screen)
        @input = if text.nil? || text.size.zero?
          Curses.window screen
        else
          text
        end
      end
    end

    @@events = []

    class << self
      def input_waiting(twitter)
        loop do
          input = STDIN.noecho(&:gets)
          twitter.pause
          callback(input.chomp, twitter)
          twitter.resume
        end
      end

      def new(&blk)
        @@events << blk
      end

      def callback(input, twitter)
        return if !@@events
        hook = []
        @@events.each do |c|
          hook << c.call(input, twitter)
        end
        if !hook.include?(true)
          puts "Command not found".color
        end
      end
    end
  end
end