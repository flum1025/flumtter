module Flumtter
  module TimeLine
    class Base
      include Util

      @@elements = []

      def self.[](key)
        @@elements[key]
      end

      def initialize(object, twitter)
        @object = object
        @twitter = twitter
        @@elements << object
      end

      def to_s
        text = <<~EOF.color(fg_color)
          #{header}
          #{user}
          #{body}
          #{footer}
        EOF
        bg_color.nil? ? text : text.background_color(bg_color)
      end

      private
      def user
        "#{@object.user.name} (@#{@object.user.screen_name})"
      end

      def color
        :white
      end

      def fg_color
        case color
        when Symbol
          color
        when Array
          color[0]
        end
      end

      def bg_color
        case color
        when Symbol
          nil
        when Array
          color[1]
        end
      end

      def created_at
        parse_time(@object.created_at)
      end

      def index
        @@elements.rindex(@object)
      end

      def header
        "#{index} ".ljust(Terminal.x, ?-)
      end

      def body
        @object.text.nl
      end

      def footer
        "#{created_at}".ljust(Terminal.x, nil, @object.via)
      end
    end
  end
end
