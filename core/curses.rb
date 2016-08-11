require 'curses'

module Flumtter
  class Curses
    TextSet = {
      wrong_number: [
      "【Wrong number!!!!!!!】",
      "Please re-setting.",
      "Please enter..."
      ],
      command_not_found: [
      "【Command not found】",
      "Please re-setting.",
      "Please enter..."
      ],
      too_small_error: [
        "【Too small window】",
        "Terminal window is too small."
      ]
    }

    class CursesException < FlumtterException;end

    class ObjectError < CursesException;end

    class TooSmallWindow < CursesException;end

    class << self
      def window(texts)
        Window.update
        raise TooSmallWindow if texts.size + 6 > Window.y
        raise ObjectError, 'String only' if texts.map{|a|a.kind_of?(Array)}.include?(true)
        y = x = 2
        ::Curses.clear
        s = ::Curses.stdscr.subwin(5+texts.size, 60, y, x)
        s.box(?|, ?-, ?*)
        texts.each do |text|
          s.setpos(x, y)
          s.addstr(text)
          x += 1
        end
        s.refresh
        s.setpos(x, y)
        input = s.getstr
        s.clear
        s.close
        ::Curses.close_screen
        input.encode!('UTF-16', 'UTF-8', :invalid => :replace, :replace => '').encode!('UTF-8', 'UTF-16')
      rescue TooSmallWindow
        window TextSet[:too_small_error] << "Please use more 60*#{texts.size+7}"
      rescue => e
        ::Curses.close_screen
        Flumtter.error e
        raise e
      end
    end
  end
end

module Curses
  module_function
  def clear
    Flumtter::Window.update
    s = Curses.stdscr.subwin(Flumtter::Window.y-2, Flumtter::Window.x-2, 1, 1)
    s.refresh
    s.clear
    s.close
  end
end