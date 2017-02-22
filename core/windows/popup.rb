require_relative 'base'

module Flumtter
  module Window
    class Popup < Base
      def show
        Dispel::Screen.open do |screen|
          Dispel::Window.open(@hight, @width, 0, 0) do |win|
            win.box(?|,?-,?*)
            win.setpos(win.cury+2, win.curx+1)
            win.addstr @title.title
            win.setpos(win.cury+1, 1)
            win.addstr "¯"*(@title.title.size+2)

            add_multiline_str(win, @body)

            win.getch
          end
        end
      end
    end

    class Popup::Error < Popup
      def initialize(body)
        super("Error", body)
      end
    end

    class Popup::Success < Popup
      def initialize(body)
        super("Success", body)
      end
    end
  end
end
