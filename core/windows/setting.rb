require_relative 'base'

module Flumtter
  module Window
    class Setting < Dialog
      def initialize(*args)
        super
        @hight += 1
      end

      def dynamic_view(&blk)
        @view = blk
      end

      def show(recall=false)
        Dispel::Screen.open do |screen|
          view = @view.nil? ? "" : @view.call
          Dispel::Window.open(@hight + (view.nil? ? 0 : view.size_of_lines), @width, 0, 0) do |win|
            win.box(?|,?-,?*)
            win.setpos(win.cury+2, win.curx+1)
            win.addstr @title.title
            win.setpos(win.cury+1, 1)
            win.addstr "¯"*(@title.title.size+2)

            add_multiline_str(win, @body)
            win.setpos(win.cury+1, 1)
            add_multiline_str(win, view)

            win.setpos(win.cury+2, 1)
            win.addstr "help: ?".rjust(win.maxx - 2)
            win.setpos(win.cury+1, 1)
            call getstr(win)
          end
        end
      rescue Dispel::Recall
        show(recall)
      rescue Dispel::NoCommandError => e
        Window::Popup::Error.new(e.class.to_s).show
        show(recall) if recall
      end
    end
  end
end
