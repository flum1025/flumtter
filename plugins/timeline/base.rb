module Flumtter
  module TimeLine
    class Base
      @@elements = []

      def initialize(object, twitter)
        @object = object
        @twitter = twitter
        @@elements << object
      end

      def to_s
        <<~EOF.color(color)
          #{header}
          #{user}
          #{body}
          #{footer}
        EOF
      end

      private
      def user
        "#{@object.user.name} (@#{@object.user.screen_name})"
      end

      def color
        :white
      end

      def created_at
        @object.created_at.strftime("%Y/%m/%d %H:%M:%S")
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
