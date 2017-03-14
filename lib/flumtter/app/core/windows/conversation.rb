module Flumtter
  module Window
    class ConversationBuf < Buf::Buf
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

    class Conversation < Window::Buf::Screen
      include Command::Tweet

      def initialize(obj, twitter)
        buf = ConversationBuf.new(twitter)
        buf.add(obj)
        super(buf, "Conversation")
        add_command(twitter)
      end
    end
  end
end
