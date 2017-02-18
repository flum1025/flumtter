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
        command("f", "Favorite") do |m|
          error_handler do
            obj, _ = parse_index(m[1])
            Plugins::Favorite.favorite(obj, twitter)
          end
        end
        command("t", "Retweet") do |m|
          error_handler do
            obj, _ = parse_index(m[1])
            Plugins::Retweet.retweet(obj, twitter)
          end
        end
        command("r", "Reply") do |m|
          error_handler do
            obj, m2 = parse_index(m[1])
            Plugins::Reply.update(obj, m2, twitter)
          end
        end
      end
    end

    Keyboard.add("m", "Mention") do |m, twitter|
      self::Mention.new(twitter).show
    end
  end
end
