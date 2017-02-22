require_relative 'userbase'

module Flumtter
  module Window
    class FollowingBuf < UserBuf
      def prefetch
        @ids ||= @twitter.rest.friend_ids(@user.id).to_a
        adds(
          @twitter.rest.users @ids.pop(100)
        )
      end
    end

    class Following < User
      def initialize(user, twitter)
        super(FollowingBuf.new(user, twitter), "#{user.screen_name}'s Following", twitter)
      end
    end
  end
end
