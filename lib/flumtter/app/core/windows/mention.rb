module Flumtter
  module Window
    class MentionBuf < Buf::Buf
      Options = {count: 50}

      def initialize(twitter)
        @twitter = twitter
        super(TweetBase)
      end

      def prefetch
        adds(
          @twitter.rest.mentions(
            @buf.last.nil? ? Options : Options.merge(max_id: @buf.last.id-1)
          )
        )
      end
    end

    class Mention < Buf::Screen
      include Command::Tweet

      def initialize(twitter)
        super(MentionBuf.new(twitter), "#{twitter.account.screen_name}'s Mentions")
        add_command(twitter)
      end
    end
  end
end
