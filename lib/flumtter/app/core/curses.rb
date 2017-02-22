require 'dispel'
module Dispel
  class CloseWindow < StandardError; end
  class NoCommandError < StandardError; end
  class Recall < StandardError; end

  class Window
    class << self
      def open(*args)
        win = Curses::Window.new(*args)
        win.keypad(true)
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
    def addstr(win, str)
      win.setpos(win.cury+1, 1)
      win.addstr str
    end

    def add_multiline_str(win, str)
      str.each_line do |line|
        addstr(win, line.chomp)
      end
    end

    def getstr(win, ex=[])
      buf = ""
      x = win.curx
      loop do
        input = Dispel::Keyboard.translate_key_to_code(win.getch)
        ex.each do |k|
          return input if input == k
        end

        case input
        when :"Ctrl+c"
          raise CloseWindow
        when :enter
          return buf
        when :escape
          raise CloseWindow
        when :left
          if win.curx > x
            win.setpos(win.cury, win.curx-1)
          end
        when :right
          if win.curx <= buf.size
            win.setpos(win.cury, win.curx+1)
          end
          # TODO: 文字移動して削除入力
        when :backspace
          buf.chop!
          while win.curx > x
            win.setpos(win.cury, win.curx-1)
            win.delch()
            win.insch(" ")
          end
          win.addstr(buf)
        when String
          buf << input.force_encoding("utf-8")
          win.setpos(win.cury, win.curx)
          win.addstr(input)
        else
          p input
        end
      end
    rescue NoMethodError => e
      if e.backtrace.shift =~ /keyboard.rb:210/
        raise Dispel::Recall
      else
        raise e
      end
    end
  end
end

module Flumtter
  sarastire 'core/windows'
end
