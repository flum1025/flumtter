module Flumtter
  module Window
    class TweetBuf < Buf::Buf
      Options = {count: 50}

      def initialize(user, twitter)
        @twitter = twitter
        @user = user
        super(TweetBase)
      end

      def prefetch
        adds(
          @twitter.rest.user_timeline(
            @user.id,
            @buf.last.nil? ? Options : Options.merge(max_id: @buf.last.id-1)
          )
        )
      end
    end

    class Tweet < Buf::Screen
      include Command::Tweet

      def initialize(user, twitter)
        super(TweetBuf.new(user, twitter), "#{user.screen_name}'s Tweets")
        add_command(twitter)
      end
    end
  end
end
