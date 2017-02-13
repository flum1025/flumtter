require_relative 'base'

module Flumtter
  module TimeLine
    class DirectMessage < Base
      def color
        Setting.dig(:color, :timeline, :directmessage) || :white
      end

      def user
        "#{@object.sender.name} (@#{@object.sender.screen_name})"
      end

      def footer
        created_at
      end
    end
  end
end
