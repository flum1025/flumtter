require_relative 'dialog'

module Flumtter
  module Window
    module Buf
      class Buf
        attr_accessor :cursor
        def initialize(base_cls=Element)
          @base_cls = base_cls
          @buf = []
          @cursor = 0
        end

        def cursor=(n)
          if n <= 0
            @cursor = 0
          else
            @cursor = n
          end
        end

        def [](key)
          @buf[key]
        end

        def adds(objects)
          objects.each do |obj|
            @buf << @base_cls.new(obj, @buf.size)
          end
        end

        def add(object)
          @buf << @base_cls.new(object, @buf.size)
        end

        def get
          if @buf[@cursor].nil?
            prefetch
          end
          elem = @buf[@cursor]
          @cursor += 1
          elem
        end

        def prev
          @cursor -= 1
        end
      end

      class Element
        attr_reader :object
        def initialize(object, index)
          @object = object
          @index = index
        end

        def element
          @text ||= <<~EOF
            #{header}
            #{user}
            #{body}
            #{footer}
          EOF
        end

        def width
          Terminal.x-2
        end
      end

      class Screen < Dialog
        include Util
        EnableKey = %i(left right up down)

        def initialize(buf, title, body="")
          @title, @body = title, body
          @commands = []
          @buf = buf
          @range = 0...0
        end

        def call(str)
          if str == "?"
            Window::Popup.new("Command List", <<~EOF).show
              #{Command.list(@commands)}
            EOF
            move(:keep)
            raise Dispel::Recall
          elsif str == :left
            move(:page)
            raise Dispel::Recall
          elsif str == :right
            raise Dispel::Recall
          elsif str == :up || str == :down
            move(str)
            raise Dispel::Recall
          else
            move(:keep)
            @commands.each do |command|
              if m = str.match(command.command)
                command.call(m)
                raise Dispel::Recall
              end
            end
            raise Dispel::NoCommandError
          end
        end

        def id2obj(id)
          obj = @buf[id.to_i]
          raise IndexError if obj.nil?
          obj.object
        end

        def move(type)
          case type
          when :up
            @buf.cursor = @range.min - 1
          when :down
            @buf.cursor = @range.min + 1
          when :page
            i, count = 0, 0
            elem = @buf[@range.min-i].element
            while (count += elem.size_of_lines + 2) < @lines
              i -= 1
              elem = @buf[@range.min-i].element
            end
            @buf.cursor = @range.min+i
          when :keep
            @buf.cursor = @range.min
          end
        end

        def show
          Dispel::Screen.open do |screen|
            Dispel::Window.open(screen.lines, screen.columns, 0, 0) do |win|
              win.box(?|,?-,?*)
              win.setpos(win.cury+2, win.curx+1)
              win.addstr @title.title
              win.setpos(win.cury+1, 1)
              win.addstr "¯"*(@title.title.size+2)

              add_multiline_str(win, @body)

              start = @buf.cursor
              loop do
                elem = @buf.get.element
                if (@lines = screen.lines) > win.cury + elem.size_of_lines + 4
                  add_multiline_str(win, elem)
                  win.setpos(win.cury+1,1)
                else
                  @buf.prev
                  break
                end
              end
              @range = start...@buf.cursor

              win.setpos(win.cury+2, 1)
              win.addstr "help: ?".rjust(win.maxx - 2)
              win.setpos(win.cury+1, 1)
              call getstr(win, EnableKey)
            end
          end
        rescue Dispel::Recall
          show
        rescue Dispel::NoCommandError => e
          Window::Popup::Error.new(e.class.to_s).show
          show
        end
      end
    end
  end
end
