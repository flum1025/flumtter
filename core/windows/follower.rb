require_relative 'userbase'

module Flumtter
  module Window
    class FollowerBuf < UserBuf
      def prefetch
        @ids ||= @twitter.rest.follower_ids(@user.id).to_a
        adds(
          @twitter.rest.users @ids.pop(100)
        )
      end
    end

    class Follower < User
      def initialize(user, twitter)
        super(FollowerBuf.new(user, twitter), "#{user.screen_name}'s Follower", twitter)
      end
    end
  end
end
