module Flumtter
  plugin do
    class self::Buf < Window::Buf::Buf
      Options = {count: 50}

      def initialize(twitter)
        @twitter = twitter
        super(Window::TweetBase)
      end

      def prefetch
        adds(
          @twitter.rest.mentions(
            @buf.last.nil? ? Options : Options.merge(max_id: @buf.last.id-1)
          )
        )
      end
    end

    class self::Mention < Window::Buf::Screen
      def initialize(twitter)
        super(Plugins::Mention::Buf.new(twitter), "#{twitter.account.screen_name}'s Mentions")
        TweetBaseCommand.add(self)
      end
    end

    Keyboard.add("m", "Mention") do |m, twitter|
      self::Mention.new(twitter).show
    end
  end
end
