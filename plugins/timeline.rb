module Flumtter
  module TimeLineElement
    Plugins.new(:tweet) do |object, twitter|
      next if Mute.mute?(object)
      if object.retweet?
        Retweet.new(object)
      else
        if object.user.id == twitter.id
          MyTweet.new(object)
        else
          Tweet.new(object)
        end
      end
    end

    Plugins.new(:favorite) do |object, twitter|
      next if Mute.mute?(object)
      Fav.new(object) if object.target.id == twitter.id || object.source.id == twitter.id
    end
    
    Plugins.new(:directmessage) do |object, twitter|
      next if Mute.mute?(object)
      DirectMessage.new(object)
    end
  end
end