require 'io/console'

module Flumtter
  class Keyboard
    extend Util

    class Command
      attr_reader :name, :command, :help
      def initialize(command, help="", &blk)
        @name = command.is_a?(Regexp) ? command.inspect : command
        @command = command.is_a?(String) ? command.to_reg : command
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
            #{@@commands.map{|c|[c.name, c.help].join("\n#{" "*4}")}.join("\n")}

            For more information, please see the following Home page.
            http://github.com/flum1025/flumtter3
            This software is released under the MIT License
            Copyright © @flum_ 2016
          EOF
        else
          @@commands.each do |command|
            if m = input.match(command.command)
              return command.call(m, twitter)
            end
          end
          puts "Command not found".color
        end
      end

      def add(command, help, &blk)
        @@commands << Command.new(command, help) do |*args|
          begin
            blk.call(*args)
          rescue Exception => e
            error e
          end
        end
      end
    end
  end
end
