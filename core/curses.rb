require 'dispel'
module Dispel
  class CloseWindow < StandardError; end
  class NoCommandError < StandardError; end

  class Window
    class << self
      def open(*args)
        win = Curses::Window.new(*args)
        yield win
      rescue CloseWindow
      ensure
        win.refresh
        win.close
      end

      def close
        raise CloseWindow
      end
    end
  end

  module Util
    def getstr(win)
      buf = ""
      x =win.curx
      loop do
        case input = Dispel::Keyboard.translate_key_to_code(win.getch)
        when :"Ctrl+c"
          raise Interrupt
        when :enter
          return buf
        when :escape
          raise CloseWindow
        when :backspace
          buf.chop!
          while win.curx > x
            win.setpos(win.cury, win.curx-1)
            win.delch()
            win.insch(" ")
          end
          win.addstr(buf)
        else
          if input.is_a?(String)
            buf << input
            win.setpos(win.cury, win.curx)
            win.addch(input)
          end
        end
      end
    end
  end
end

module Flumtter
  sarastire 'core/windows'
end
