module Flumtter
  plugin do
    def toast(msg, subtitle, twitter)
      Toast.show(msg, subtitle: subtitle, title: "#{twitter.account.screen_name} Flumtter")
    end

    def toast_event(msg, twitter)
      Toast.show(msg, title: "#{twitter.account.screen_name} Flumtter")
    end

    Client.on_event(:tweet) do |object, twitter|
      type = object.type(twitter.account)
      if type.include?(:reply_to_me)
        toast(object.text, "Mentioned by #{object.user.screen_name}", twitter)
      elsif type.include?(:retweet) && object.retweeted_status.user.id == twitter.account.id
        toast(object.text, "Retweeted by #{object.user.screen_name}", twitter)
      end
    end

    Client.on_event(:event) do |object, twitter|
      type = object.type(twitter.account)
      if type.include?(:follow)
        toast_event("Followed by #{object.source.screen_name}", twitter)
      elsif type.include?(:favorite)
        toast(object.target_object.text, "Favorited by #{object.source.screen_name}", twitter)
      end
    end

    Client.on_event(:directmessage) do |object, twitter|
      unless object.sender.id == twitter.account.id
        toast(object.text, "Message by #{object.sender.screen_name}", twitter)
      end
    end
  end
end
