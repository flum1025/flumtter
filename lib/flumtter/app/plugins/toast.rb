module Flumtter
  plugin do
    def title(twitter)
      "#{twitter.account.screen_name} Flumtter"
    end

    Client.on_event(:tweet) do |object, twitter|
      type = object.type(twitter.account)
      if type.include?(:reply_to_me)
        Toast.new(object.text) do |t|
          t.title title(twitter)
          t.subtitle "Mentioned by #{object.user.screen_name}"
        end
      elsif type.include?(:retweet) && object.retweeted_status.user.id == twitter.account.id
        Toast.new(object.text) do |t|
          t.title title(twitter)
          t.subtitle "Retweeted by #{object.user.screen_name}"
        end
      end
    end

    Client.on_event(:event) do |object, twitter|
      type = object.type(twitter.account)
      if type.include?(:follow)
        Toast.new("Followed by #{object.source.screen_name}") do |t|
          t.title title(twitter)
        end
      elsif type.include?(:favorite) && object.target_object.user.id == twitter.account.id && object.source.id != twitter.account.id
        Toast.new(object.target_object.text) do |t|
          t.title title(twitter)
          t.subtitle "Favorited by #{object.source.screen_name}"
        end
      end
    end

    Client.on_event(:directmessage) do |object, twitter|
      unless object.sender.id == twitter.account.id
        Toast.new(object.text) do |t|
          t.title title(twitter)
          t.subtitle "Message by #{object.sender.screen_name}"
        end
      end
    end
  end
end
