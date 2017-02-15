module Flumtter
  plugin do
    def retweet(obj, twitter)
      if obj.retweeted?
        raise ExecutedError, "already retweeted"
      else
        begin
          twitter.rest.retweet(obj.id)
        rescue Twitter::Error::Forbidden => e
          if e.message == "You have already retweeted this tweet."
            raise ExecutedError, "already retweeted"
          else
            raise e
          end
        end
      end
    end

    Keyboard.add("t", "Retweet") do |m, twitter|
      error_handler do
        obj, _ = index_with_dialog(m[1], "Retweet Screen", <<~EOF)
          Please input target index.
        EOF
        if_tweet(obj, twitter) do |tweet|
          retweet(tweet, twitter)
        end
      end
    end
  end
end
