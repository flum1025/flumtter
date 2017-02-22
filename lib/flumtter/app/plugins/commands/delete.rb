module Flumtter
  plugin do
    def delete(obj, twitter)
      if obj.user.id == twitter.account.id
        begin
          twitter.rest.destroy_status(obj.id)
        rescue Twitter::Error::NotFound => e
          raise ExecutedError, e.message
        end
      else
        raise ExecutedError, "You may not delete another user's status."
      end
    end

    Keyboard.add("k", "Delete") do |m,twitter|
      error_handler do
        obj, _ = index_with_dialog(m[1], "Delete Screen", <<~EOF)
          Please input target index.
        EOF
        if_tweet(obj, twitter) do |tweet|
          delete(tweet, twitter)
        end
      end
    end
  end
end
