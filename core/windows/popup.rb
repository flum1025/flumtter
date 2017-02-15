module Flumtter
  class Popup
    include Dispel::Util

    def initialize(title, body, 
                   hight=body.each_line.to_a.size,
                   width=body.each_line.max_by{|str|str.size}.size+2)
      @title = title
      @body = body
      @hight = hight + 8
      @width = [width,title.title.exact_size+2].max
    end

    def show
      Dispel::Screen.open do |screen|
        Dispel::Window.open(@hight, @width, 0, 0) do |win|
          win.box(?|,?-,?*)
          win.setpos(win.cury+2, win.curx+1)
          win.addstr @title.title
          win.setpos(win.cury+1, 1)
          win.addstr "¯"*(@title.title.size+2)

          @body.each_line do |line|
            win.setpos(win.cury+1, 1)
            win.addstr line.chomp
          end

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
end
