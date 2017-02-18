module Flumtter
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

    def self.list(commands)
      char_len = commands.max_by{|c|c.name.size}.name.size + 1
      commands.map do |c|
        c.name.ljust(char_len) + c.help
      end.join("\n")
    end
  end
end
