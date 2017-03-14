module Flumtter
  module Command::Tweet
    def add_command(twitter)
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
      command("g", "Conversation") do |m|
        error_handler do
          obj, _ = parse_index(m[1])
          if_tweet(obj, twitter) do |tweet|
            Window::Conversation.new(tweet, twitter).show
          end
        end
      end
    end
  end
end
