require 'io/console'

module Flumtter
  class Keyboard
    class Command
      attr_reader :command, :help
      def initialize(command, help="", blk)
        @command = command
        @help = help
        @blk = blk
      end

      def call(*args)
        @blk.call(*args)
      end
    end

    class << self
      @@commands = []

      def input(twitter)
        loop do
          input = STDIN.noecho(&:gets)
          twitter.pause
          callback(input.chomp, twitter)
          twitter.resume
        end
      end

      def callback(input, twitter)
        if input == "?"
          Dialog.new("Command List", <<~EOF).show(false, false)
            #{@@commands.map{|c|[c.command.inspect, c.help].join("\n#{" "*4}")}.join("\n")}
          EOF
        else
          @@commands.each do |command|
            if m = input.match(command.command)
              return command.call(m)
            end
          end
          puts "Command not found".color
        end
      end

      def add(command, help, &blk)
        @@commands << Command.new(command, help, blk)
      end
    end
  end
end
