module Flumtter
  plugin do
    class self::Buf < Window::Buf::Buf
      Options = {count: 50}

      def initialize(twitter)
        @twitter = twitter
        super(Window::DMBase)
      end

      def prefetch
        adds(
          @twitter.rest.direct_messages(
            @buf.last.nil? ? Options : Options.merge(max_id: @buf.last.id-1)
          )
        )
      end
    end

    class self::DirectMessage < Window::Buf::Screen
      include Command::DM

      def initialize(twitter)
        super(Plugins::Directmessages::Buf.new(twitter), "#{twitter.account.screen_name}'s DirectMessages")
        add_command(twitter)
      end
    end

    Keyboard.add("b", "DirectMessages") do |m, twitter|
      self::DirectMessage.new(twitter).show
    end
  end
end
