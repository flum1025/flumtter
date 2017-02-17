module Flumtter
  plugin do
    class self::Profile
      include Util
      alias_method :cvr, :command_value_regexp

      def initialize(twitter)
        @twitter = twitter
        loop do
          dialog = Window::Dialog.new("Change Profile", <<~EOF)
            Please select item you want to change with new profile.
            Syntax: '\#{item} \#{new profile}'
          EOF
          %w(name description url location).each do |meth|
            dialog.command(cvr(meth)) do |m|
              begin
                send(meth, m)
              rescue CloseWindow
                binding.pry
                return
              end
            end
          end
          dialog.show
        end
      end

      def name(m)

      end

      def description(m)

      end

      def url(m)

      end

      def location(m)

      end
    end

    Keyboard.add("c", "Change Profile") do |m, twitter|
      self::Profile.new(twitter)
    end
  end
end
