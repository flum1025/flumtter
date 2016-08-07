module Flumtter
  class Help
    @@texts = ["【Keyboard shortcuts】"]
    Footer = [
      "",
      "For more information, please see the following Home page.",
      "http://github.com/flum1025/flumtter3",
      "This software is released under the MIT License",
      "Copyright © @flum_ 2016"
    ]

    class << self
      def add text
        @@texts << text
      end
      
      def show
        Curses.window @@texts + Footer
      end
    end
  end
  
  Help.add "?:This menu"
  
  Command.new do |input, twitter|
    case input
    when /^(\?|？)(\s*|　*)(.*)/
      Help.show
      true
    end
  end
end