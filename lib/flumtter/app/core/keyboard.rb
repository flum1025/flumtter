require 'io/console'

module Flumtter
  class Keyboard
    extend Util

    class << self
      @@commands = []

      def input(twitter)
        loop do
          input = STDIN.noecho(&:gets)
          next if input.nil?
          twitter.pause
          callback(input.chomp, twitter)
          twitter.resume
        end
      rescue Interrupt
      end

      def callback(input, twitter)
        if input == "?"
          Window::Popup.new("Command List", <<~EOF).show
            #{Command.list(@@commands)}

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
          rescue SystemExit => e
            raise e
          rescue Exception => e
            error e
          end
        end
      end
    end
  end
end
