require_relative 'base'

module Flumtter
  module TimeLine
    class DeletedTweet < Base
      class TweetNotFound < KeyError; end

      def initialize(object, twitter)
        object = @@elements.find{|e|e.is_a?(Twitter::Tweet) && e.id == object.id}
        raise TweetNotFound if object.nil?
        super(object, twitter)
      end

      def color
        Setting.dig(:color, :timeline, :deletedtweet) || :white
      end

      def header
        "DELETED ".ljust(Terminal.x, ?-)
      end
    end
  end
end
