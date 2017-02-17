require_relative 'base'

module Flumtter
  module Window
    class Command
      attr_reader :command, :help
      def initialize(command, help="", blk)
        @command = command
        @help = help
        @blk = blk
      end

      def call(*args)
        @blk.call(*args)
      end
    end

    class Dialog < Base
      def initialize(*args)
        super
        @commands = []
      end

      def command(command, help="", &blk)
        @commands << Command.new(command, help, blk)
      end

      def call(str)
        if str == "?"
          Window::Popup.new("Command List", <<~EOF).show
            #{@commands.map{|c|[c.command.inspect, c.help].join("\n#{" "*4}")}.join("\n")}
          EOF
          raise Dispel::Recall
        else
          @commands.each do |command|
            if m = str.match(command.command)
              return command.call(m)
            end
          end
          raise Dispel::NoCommandError
        end
      end

      def show(recall=false, help=true)
        Dispel::Screen.open do |screen|
          Dispel::Window.open(@hight, @width, 0, 0) do |win|
            win.box(?|,?-,?*)
            win.setpos(win.cury+2, win.curx+1)
            win.addstr @title.title
            win.setpos(win.cury+1, 1)
            win.addstr "¯"*(@title.title.size+2)

            add_multiline_str(win, @body)

            if block_given?
              yield win
            else
              win.setpos(win.cury+2, 1)
              if help
                win.addstr "help: ?".rjust(win.maxx - 2)
                win.setpos(win.cury+1, 1)
              end
              call getstr(win)
            end
          end
        end
      rescue Dispel::Recall
        show(recall, help)
      rescue Dispel::NoCommandError => e
        Window::Popup::Error.new(e.class.to_s).show
        show(recall, help) if recall
      end
    end
  end
end
