# Coding: UTF-8
require 'twitter'

@object_index = 0

def config(data)
  @user_id = data[0].to_i
  @screen_name = data[1]
  @rest_client = Twitter::REST::Client.new do |config|
    config.consumer_key        = data[2]
    config.consumer_secret     = data[3]
    config.access_token        = data[4]
    config.access_token_secret = data[5]
  end
  @stream_client = Twitter::Streaming::Client.new do |config|
    config.consumer_key        = data[2]
    config.consumer_secret     = data[3]
    config.access_token        = data[4]
    config.access_token_secret = data[5]
  end
end

@stream = true

def stream
  puts "@#{@screen_name}'s stream_start!"
  @stream_client.user(@option) do |object|
    loop do
      unless @stream
        sleep(1)
      else
        break
      end
    end
    @x = `tput cols`.to_i
    @y = `tput lines`.to_i
    case object
    when Twitter::Tweet
      kind = :tweet
    when Twitter::Streaming::Event
      kind = :event
    when Twitter::Streaming::FriendList
      kind = :friendlist
    when Twitter::Streaming::DeletedTweet
      kind = :deletedtweet
    when Twitter::DirectMessage
      kind = :directmessage
    end
    @temp[@object_index += 1] = object
    callback(kind, object)
  end
rescue => ex
  error(ex)
end

def tweet(text)
  @rest_client.update(text)
end

def reply(text, id)
  @rest_client.update(text, :in_reply_to_status_id => id)
end

def retweet(id)
  @rest_client.retweet(id)
end

def favorite(id)
  @rest_client.favorite(id)
end

def direct_message(user, text)
  @rest_client.create_direct_message(user, text)
end

def user_info(screen_name)
  return @rest_client.user(screen_name)
end

def get_mention(opt={})
  return @rest_client.mentions(opt)
end

def get_favorite(id, opt={})
  @rest_client.favorites(id, opt)
end

def get_user_timeline(id, opt={})
  @rest_client.user_timeline(id, opt)
end

def get_follower_ids(id)
  return @rest_client.follower_ids(id).to_a
end

def get_following_ids(id)
  return @rest_client.friend_ids(id).to_a
end

def get_users(id)
  return @rest_client.users(id)
end

def friendship(id, id2)
  return @rest_client.friendship(id, id2)
end

def block(id)
  @rest_client.block(id)
end

def unblock(id)
  @rest_client.unblock(id)
end

def follow(id)
  @rest_client.follow(id)
end

def unfollow(id)
  @rest_client.unfollow(id)
end

