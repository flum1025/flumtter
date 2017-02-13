module Flumtter
  class Popup
    extend Dispel::Util
    include Dispel::Util

    class << self
      def overall
        Dispel::Screen.open do |screen|
          Dispel::Window.open(screen.lines, screen.columns, 0, 0) do |win|
            win.addstr("Please access the following URL.".center(screen.columns))
            win.addstr("And get the Pin code.".center(screen.columns))
            win.getch
          end
        end
      end
    end
  end
end
