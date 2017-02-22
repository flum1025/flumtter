module Flumtter
  module Window
    class FavoriteBuf < Buf::Buf
      Options = {count: 50}

      def initialize(user, twitter)
        @twitter = twitter
        @user = user
        super(TweetBase)
      end

      def prefetch
        adds(
          @twitter.rest.favorites(
            @user.id,
            @buf.last.nil? ? Options : Options.merge(max_id: @buf.last.id-1)
          )
        )
      end
    end

    class Favorite < Buf::Screen
      include Command::Tweet

      def initialize(user, twitter)
        super(FavoriteBuf.new(user, twitter), "#{user.screen_name}'s Favorites")
        add_command(twitter)
      end
    end
  end
end
