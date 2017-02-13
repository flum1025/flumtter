require_relative 'event'

module Flumtter
  module TimeLine
    class Tweet < Base
      def color
        Setting.dig(:color, :timeline, :normal) || :white
      end
    end

    class SelfTweet < Base
      def color
        Setting.dig(:color, :timeline, :self) || :white
      end
    end

    class ReplyTweet < Base
      def color
        Setting.dig(:color, :timeline, :reply) || :white
      end
    end

    class Retweet < Event
      def source_user
        @object.user.screen_name
      end

      def info
        @object.retweeted_status.retweet_count
      end

      def color
        Setting.dig(:color, :timeline, :retweet) || :white
      end
    end

    class Quote < Event
      def source_user
        @object.user.screen_name
      end

      def info
        @object.retweeted_status.retweet_count
      end

      def color
        Setting.dig(:color, :timeline, :quote) || :white
      end
    end
  end
end
