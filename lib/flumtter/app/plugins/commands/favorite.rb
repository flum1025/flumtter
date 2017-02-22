module Flumtter
  plugin do
    def favorite(obj, twitter)
      if obj.favorited?
        raise ExecutedError, "already favorited"
      else
        twitter.rest.favorite(obj.id)
      end
    end

    Keyboard.add("f", "Favorite") do |m,twitter|
      error_handler do
        obj, _ = index_with_dialog(m[1], "Favorite Screen", <<~EOF)
          Please input target index.
        EOF
        if_tweet(obj, twitter) do |tweet|
          favorite(tweet, twitter)
        end
      end
    end
  end
end
