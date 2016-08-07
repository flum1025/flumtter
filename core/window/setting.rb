module Flumtter
  module Setting
    class Base
    end
    
    class Setting
      Header = [
        "【Setting Menu】",
        "Please select one among several.",
        ""
      ]
      @@texts = []
      @@events = []

      class << self
        def add text
          @@texts << text
        end

        def show
          input = Curses.window Header + @@texts
          callback(input.chomp)
        end

        def new(&blk)
          @@events << blk
        end
        
        $userConfig[:save_data][:setting] ||= {}

        def callback(input)
          return if !@@events
          hook = []
          @@events.each do |c|
            hook << c.call(input, $userConfig[:save_data][:setting])
          end
          if !hook.include?(true)
            puts "Command not found".color
          end
        end
      end
    end
  end

  Help.add "s:Setting menu"

  Command.new do |input, twitter|
    case input
    when /^(s|S|ｓ|Ｓ)(\s*|　*)(.*)/
      Setting::Setting.show
      true
    end
  end
end