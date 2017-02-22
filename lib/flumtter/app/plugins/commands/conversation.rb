module Flumtter
  plugin do
    class self::Buf < Window::Buf::Buf
      def initialize(twitter)
        @twitter = twitter
        super(Window::TweetBase)
      end

      def prefetch
        id = @buf.last&.object&.in_reply_to_status_id
        add(
          @twitter.rest.status(id)
        ) unless id.nil?
      end
    end

    class self::Conversation < Window::Buf::Screen
      include Command::Tweet

      def initialize(obj, twitter)
        buf = Plugins::Conversation::Buf.new(twitter)
        buf.add(obj)
        super(buf, "Conversation")
        add_command(twitter)
      end
    end

    Keyboard.add("g", "Conversation") do |m, twitter|
      error_handler do
        obj, _ = index_with_dialog(m[1], "Conversation Screen", <<~EOF)
          Please input target index.
        EOF
        if_tweet(obj, twitter) do |tweet|
          self::Conversation.new(tweet, twitter).show
        end
      end
    end
  end
end
