require_relative 'event'

module Flumtter
  module TimeLine
    class FavBase < Event
      def source_user
        @object.source.screen_name
      end

      def info
        @object.target_object.favorite_count
      end

      def user
        "#{@object.target_object.user.name} (@#{@object.target_object.user.screen_name})"
      end

      def created_at
        @object.target_object.created_at.strftime("%Y/%m/%d %H:%M:%S")
      end

      def body
        @object.target_object.text.nl
      end

      def footer
        "#{created_at}".ljust(Terminal.x, nil, @object.target_object.via)
      end
    end

    class Favorite < FavBase
      def color
        Setting.dig(:color, :timeline, :fav) || :white
      end
    end

    class UnFavorite < FavBase
      def color
        Setting.dig(:color, :timeline, :unfav) || :white
      end
    end
  end
end
