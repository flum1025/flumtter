module Flumtter
  plugin do
    def unfavorite(obj, twitter)
      begin
        twitter.rest.unfavorite(obj.id)
      rescue Twitter::Error::NotFound => e
        if e.message == "No status found with that ID."
          raise ExecutedError, "not favorited"
        else
          raise e
        end
      end
    end

    Keyboard.add("l", "UnFavorite") do |m,twitter|
      error_handler do
        obj, _ = index_with_dialog(m[1], "UnFavorite Screen", <<~EOF)
          Please input target index.
        EOF
        if_tweet(obj, twitter) do |tweet|
          unfavorite(tweet, twitter)
        end
      end
    end
  end
end
