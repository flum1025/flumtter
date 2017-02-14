module Flumtter
  sarastire 'plugins/timeline'

  plugin do
    Client.on_event(:tweet) do |object, twitter|
      type = object.type(twitter.account)
      cls = if type.include?(:quote)
        TimeLine::Quote
      elsif type.include?(:retweet)
        TimeLine::Retweet
      elsif type.include?(:self_tweet)
        TimeLine::SelfTweet
      elsif type.include?(:reply_to_me)
        TimeLine::ReplyTweet
      else
        TimeLine::Tweet
      end
      puts cls.new(object, twitter).to_s
    end

    Client.on_event(:event) do |object, twitter|
      type = object.type(twitter.account)
      cls = if type.include?(:favorite)
        TimeLine::Favorite
      elsif type.include?(:unfavorite)
        TimeLine::UnFavorite
      end
      puts cls.new(object, twitter).to_s
    end

    Client.on_event(:directmessage) do |object, twitter|
      puts TimeLine::DirectMessage.new(object, twitter).to_s
    end

    Client.on_event(:deletedtweet) do |object, twitter|
      begin
        puts TimeLine::DeletedTweet.new(object, twitter).to_s
      rescue TimeLine::DeletedTweet::TweetNotFound
      end
    end
  end
end
