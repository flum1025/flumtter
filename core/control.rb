# Coding: UTF-8
require 'io/console'

@userConfig[:curses_setting] ||= {}
@userConfig[:curses_setting][:help] = []
@userConfig[:curses_setting][:help].push("【Keyboard shortcuts】")
@userConfig[:curses_setting][:help].push("r:Reply")
@userConfig[:curses_setting][:help].push("t:Retweet")
@userConfig[:curses_setting][:help].push("f:Favorite")
@userConfig[:curses_setting][:help].push("n:New tweet")
@userConfig[:curses_setting][:help].push("d:Direct message")
@userConfig[:curses_setting][:help].push("p:User profile")
@userConfig[:curses_setting][:help].push("m:Mention")
@userConfig[:curses_setting][:help].push("o:Paku-ru")
@userConfig[:curses_setting][:help].push("u:Change profile")
@userConfig[:curses_setting][:help].push("e:Exit")
@userConfig[:curses_setting][:help].push("c:Clear the terminal screen")
@userConfig[:curses_setting][:help].push("z:Forced termination and clear the terminal screen")
@userConfig[:curses_setting][:help].push("s:Setting menu")
@userConfig[:curses_setting][:help].push("a:Account change")
@userConfig[:curses_setting][:help].push("?:This menu")
@userConfig[:curses_setting][:help].push("q:Open new terminal")
@userConfig[:curses_setting][:help].push("\n")
@userConfig[:curses_setting][:help].push("For more information, please see the following Home page.")
@userConfig[:curses_setting][:help].push("http://github.com/flum1025/flumtter3")
@userConfig[:curses_setting][:help].push("This software is released under the MIT License")
@userConfig[:curses_setting][:help].push("Copyright © @flum_ 2015")
  
@userConfig[:curses_setting][:reply_screen] = []
@userConfig[:curses_setting][:reply_screen].push("【Reply Screen】")
@userConfig[:curses_setting][:reply_screen].push("Please input target (num or screen_name) and tweet content.")
@userConfig[:curses_setting][:reply_screen].push("Syntax: '\#{num|screen_name} \#{content}'")
  
@userConfig[:curses_setting][:tweet_screen] = []
@userConfig[:curses_setting][:tweet_screen].push("【Tweet Screen】")
@userConfig[:curses_setting][:tweet_screen].push("Please input tweet content.")
@userConfig[:curses_setting][:tweet_screen].push("Syntax: '\#{content}'")
  
@userConfig[:curses_setting][:retweet_screen] = []
@userConfig[:curses_setting][:retweet_screen].push("【Retweet Screen】")
@userConfig[:curses_setting][:retweet_screen].push("Please input target num.")
@userConfig[:curses_setting][:retweet_screen].push("Syntax: '\#{num}'")
  
@userConfig[:curses_setting][:favorite_screen] = []
@userConfig[:curses_setting][:favorite_screen].push("【Favorite Screen】")
@userConfig[:curses_setting][:favorite_screen].push("Please input target num.")
@userConfig[:curses_setting][:favorite_screen].push("Syntax: '\#{num}'")
  
@userConfig[:curses_setting][:directmessage_screen] = []
@userConfig[:curses_setting][:directmessage_screen].push("【Direct message screen】")
@userConfig[:curses_setting][:directmessage_screen].push("Please input target (num or screen_name) and DM content.")
@userConfig[:curses_setting][:directmessage_screen].push("Syntax: '\#{num|screen_name} \#{content}'")
  
@userConfig[:curses_setting][:pakuru_screen] = []
@userConfig[:curses_setting][:pakuru_screen].push("【Paku-ru screen】")
@userConfig[:curses_setting][:pakuru_screen].push("Please input target num.")
@userConfig[:curses_setting][:pakuru_screen].push("Syntax: '\#{num}'")
  
@userConfig[:curses_setting][:change_profile_screen] = []
@userConfig[:curses_setting][:change_profile_screen].push("【Change Profile】")
@userConfig[:curses_setting][:change_profile_screen].push("Please select item you want to change with new profile.")
@userConfig[:curses_setting][:change_profile_screen].push(":name")
@userConfig[:curses_setting][:change_profile_screen].push(":description")
@userConfig[:curses_setting][:change_profile_screen].push(":url")
@userConfig[:curses_setting][:change_profile_screen].push(":location")
@userConfig[:curses_setting][:change_profile_screen].push("Syntax: '\#{item} \#{new profile}'")
@userConfig[:curses_setting][:change_profile_screen].push("")
  
@userConfig[:curses_setting][:select_user_screen] = []
@userConfig[:curses_setting][:select_user_screen].push("【Select User Screen】")
@userConfig[:curses_setting][:select_user_screen].push("Please input target (num or screen_name).")
@userConfig[:curses_setting][:select_user_screen].push("Syntax: '\#{num|screen_name}'")
  
@userConfig[:curses_setting][:reply_error] = []
@userConfig[:curses_setting][:reply_error].push("【ERROR】")
@userConfig[:curses_setting][:reply_error].push("Please input (Num or Screen_name) and tweet content.")
  
@userConfig[:curses_setting][:object_error] = []
@userConfig[:curses_setting][:object_error].push("【ERROR】")
@userConfig[:curses_setting][:object_error].push("Please select Tweet number or Event number.")
  
@userConfig[:curses_setting][:tweet_error] = []
@userConfig[:curses_setting][:tweet_error].push("【ERROR】")
@userConfig[:curses_setting][:tweet_error].push("Please input one or more word.")
  
@userConfig[:curses_setting][:retweet_error] = []
@userConfig[:curses_setting][:retweet_error].push("【ERROR】")
@userConfig[:curses_setting][:retweet_error].push("please input number only")
  
@userConfig[:curses_setting][:pakuru_error] = []
@userConfig[:curses_setting][:pakuru_error].push("【ERROR】")
@userConfig[:curses_setting][:pakuru_error].push("Please select Tweet number or Event number or DirectMessage number.")
  
@userConfig[:curses_setting][:mention_error] = []
@userConfig[:curses_setting][:mention_error].push("【ERROR】")
@userConfig[:curses_setting][:mention_error].push("Command not found")
  
@userConfig[:curses_setting][:select_user_error] = []
@userConfig[:curses_setting][:select_user_error].push("【ERROR】")
@userConfig[:curses_setting][:select_user_error].push("Please input Num or Screen_name.")

  
def object_to_id(num)
  object = @temp[num]
  case object
  when Twitter::Tweet
    id = object.id
  when Twitter::Streaming::Event
    id = object.target_object.id
  when Twitter::Streaming::FriendList
    id = nil
  when Twitter::Streaming::DeletedTweet
    id = nil
  when Twitter::DirectMessage
    id = nil
  end
  return id
end
  
def reply_screen(text=nil)
  if text.nil? || text.size.zero?
    input = subwindow(@userConfig[:curses_setting][:reply_screen])
  else
    input = text
  end
  case input
  when /^(\d+)(\s*|　*)(.*)/
    id = object_to_id($1.to_i)
    unless id.nil?
      unless $3.size.zero?
        reply("@#{@temp[$1.to_i].user.screen_name} #{$3}", id)
      else
        subwindow(@userConfig[:curses_setting][:reply_error])
      end
    else
      subwindow(@userConfig[:curses_setting][:object_error])
    end
  when /^((@|＠)[A-Za-z0-9_]{1,15})(\s*|　*)(.*)/
    unless $4.size.zero?
      tweet("#{$1} #{$4}")
    else
      subwindow(@userConfig[:curses_setting][:reply_error])
    end
  else
    subwindow(@userConfig[:curses_setting][:reply_error])
  end
end

def tweet_screen(text=nil)
  if text.nil? || text.size.zero?
    input = subwindow(@userConfig[:curses_setting][:tweet_screen])
  else
    input = text
  end
  unless input.size.zero?
    tweet(input)
  else
    subwindow(@userConfig[:curses_setting][:tweet_error])
  end
end

def retweet_screen(text=nil)
  if text.nil? || text.size.zero?
    input = subwindow(@userConfig[:curses_setting][:retweet_screen])
  else
    input = text
  end
  case input
  when /^(\d+)/
    id = object_to_id($1.to_i)
    unless id.nil?
      retweet(id)
    else
      subwindow(@userConfig[:curses_setting][:object_error])
    end
  else
    subwindow(@userConfig[:curses_setting][:retweet_error])
  end
end

def favorite_screen(text=nil)
  if text.nil? || text.size.zero?
    input = subwindow(@userConfig[:curses_setting][:favorite_screen])
  else
    input = text
  end
  case input
  when /^(\d+)/
    id = object_to_id($1.to_i)
    unless id.nil?
      favorite(id)
    else
      subwindow(@userConfig[:curses_setting][:object_error])
    end
  else
    subwindow(@userConfig[:curses_setting][:retweet_error])
  end
end

def check_dm_object(num)
  object = @temp[num]
  case object
  when Twitter::DirectMessage
    return true
  end
  return false
end

def directmessage_screen(text=nil)
  if text.nil? || text.size.zero?
    input = subwindow(@userConfig[:curses_setting][:directmessage_screen])
  else
    input = text
  end
  case input
  when /^(\d+)(\s*|　*)(.*)/
    if check_dm_object($1.to_i)
      unless $3.size.zero?
        direct_message(@temp[$1.to_i].sender.id, $3)
      else
        subwindow(@userConfig[:curses_setting][:reply_error])
      end
    else
      subwindow(@userConfig[:curses_setting][:object_error])
    end
  when /^((@|＠)[A-Za-z0-9_]{1,15})(\s*|　*)(.*)/
    unless $4.size.zero?
      direct_message($1, $4)
    else
      subwindow(@userConfig[:curses_setting][:reply_error])
    end
  else
    subwindow(@userConfig[:curses_setting][:reply_error])
  end
end

def get_object_to_text(num)
  object = @temp[num]
  case object
  when Twitter::Tweet
    return object.text
  when Twitter::Streaming::Event
    return object.target_object.text
  when Twitter::DirectMessage
    return object.text
  end
  return nil
end

def pakuru_screen(text=nil)
  if text.nil? || text.size.zero?
    input = subwindow(@userConfig[:curses_setting][:pakuru_screen])
  else
    input = text
  end
  case input
  when /^(\d+)/
    text = get_object_to_text($1.to_i)
    unless text.nil?
      tweet(text)
    else
      subwindow(@userConfig[:curses_setting][:pakuru_error])
    end
  else
    subwindow(@userConfig[:curses_setting][:retweet_error])
  end
end

def split_text(des)
  text = des.dup
  text = text.gsub(/(\r\n|\r|\n|\f)/,"")
  arr = []
  if get_exact_size(text) > 56
    loop do
      arr << text.slice!(0..28)
      break if text.size.zero?
    end
  else
    arr << text
  end
  return arr
end

def change_profile_screen
  arr = @userConfig[:curses_setting][:change_profile_screen].dup
  user = user_info(nil)
  arr.push("name:#{user.name}")
  arr.push("description:")
  arr.concat(split_text(user.description))
  arr.push("location:#{user.location}")
  arr.push("url:#{user.url}")
  input = subwindow(arr, arr.size+5)
  case input
  when /^name\s(.*)/
    unless 1 > $1.length || 20 < $1.length
      @rest_client.update_profile(name: $1)
      text = text_color("Change name Success.", :cyan)
    else
      text = text_color("New name is too short or too long.")
    end
    print "\n#{text}\n"
  when /^description\s(.*)/
    unless 1 > $1.length || 160 < $1.length
      @rest_client.update_profile(description: $1)
      text = text_color("Change description Success.", :cyan)
    else
      text = text_color("New description is too short or too long.")
    end
    print "\n#{text}\n"
  when /^url\s(.*)/
    if 1 > $1.length || 100 < $1.length
      text = text_color("New url is too short or too long.")
    elsif $1.start_with?("http://") == false
      text = text_color("New url is wrong.")
    else
      @rest_client.update_profile(url: $1)
      text = text_color("Change url Success.", :cyan)
    end
    print "\n#{text}\n"
  when /^location\s(.*)/
    unless 1 > $1.length || 30 < $1.length
      @rest_client.update_profile(location: $1)
      text = text_color("Change location Success.", :cyan)
    else
      text = text_color("New location is too short or too long.")
    end
    print "\n#{text}\n"
  else
    text = text_color("Command not found")
    print "\n#{text}\n"
  end
end

def Mutual(following, followed_by)
  if following
    f = ">"
  else
    f = "/"
  end
  if followed_by
    fb = "<"
  else
    fb = "/"
  end
  return "#{fb}=#{f}"
end

def User_Tweet_Display(object)
  @timeline_temp[@timeline_index+=1] = object
  arr = []
  user = "#{object.user.name} (#{object.user.screen_name})"
  text = object.text
  created_at = object.created_at.strftime("%Y/%m/%d %H:%M:%S")
  via = object.source.gsub(/<(.+)\">/,"").gsub(/<\/a>/,"")
  arr << "#{@timeline_index} #{put("-", 54)}"
  arr << user
  text.each_line do |split|
    arr.concat(split_text(split.chomp))
  end
  arr << "#{created_at} #{put(" ", 54 - (get_exact_size(created_at) + get_exact_size(via) + 2))} #{via}"
  arr.push(" ")
  return arr
end

def user_tweet_screen(object)
  opt = {}
  opt["count"] = 200
  timeline = get_user_timeline(object.id, opt)
  opt["max_id"] = timeline.last.id
  arr = []
  @timeline_temp = {}
  @timeline_index = 0
  arr.push("【@#{@screen_name}'s Tweets】")
  loop do
    arr.concat(User_Tweet_Display(timeline.shift))
    break if arr.size > (@y - 17)
  end
  arr.push("Please input 'more' or 'exit'")
  arr.push("You can use '(f|t|r) \#{num}', 'r \#{num} text'")
  loop do
    input = subwindow(arr, arr.size + 5)
    case input
    when /^more$/
      arr = []
      arr.push("【@#{@screen_name}'s Tweets】")
      loop do
        if timeline.size.zero?
          timeline = get_user_timeline(object.id, opt)
          opt["max_id"] = timeline.last.id
        end
        arr.concat(User_Tweet_Display(timeline.shift))
        break if arr.size > (@y - 17)
      end
      arr.push("Please input 'more' or 'exit'")
      arr.push("You can use '(f|t|r) \#{num}', 'r \#{num} text'")
    when /^f\s(\d+)/
      favorite(@timeline_temp[$1.to_i].id)
    when /^t\s(\d+)/
      retweet(@timeline_temp[$1.to_i].id)
    when /^(r|R|ｒ|Ｒ)(\s*|　*)(\d+)(\s*|　*)(.*)/
      object = @timeline_temp[$3.to_i]
      reply("@#{object.user.screen_name} #{$5}", object.id)
    when /^exit$/
      break
    else
      subwindow(@userConfig[:curses_setting][:mention_error])
    end
  end
end

def User_Follow_Display(object)
  arr = []
  arr << "#{@favorite_index} #{put("-", 56)}"
  arr << "#{object.name} (#{object.screen_name})"
  arr << " discription:"
  arr.concat(split_text(object.description))
  arr << ""
  return arr
end

def user_follow_screen(object, kind)
  case kind
  when "follower"
    ids = get_follower_ids(object.id)
  when "following"
    ids = get_following_ids(object.id)
  end
  arr = []
  arr.push("【@#{@screen_name}'s #{kind}】")
  users = get_users(ids)
  loop do
    arr.concat(User_Follow_Display(users.shift))
    break if arr.size > (@y - 17)
  end
  arr.push("Please input 'more' or 'exit...'")
  loop do
    input = subwindow(arr, arr.size + 5)
    case input
    when /^more$/
      arr = []
      arr.push("【@#{@screen_name}'s #{kind}】")
      loop do
        arr.concat(User_Follow_Display(users.shift))
        break if arr.size > (@y - 17)
      end
      arr.push("Please input 'more' or 'exit...'")
    when /^exit$/
      break
    else
      subwindow(@userConfig[:curses_setting][:command_not_found])
    end
  end
end

def User_Favorite_Display(object)
  @favorite_temp[@favorite_index+=1] = object
  arr = []
  user = "#{object.user.name} (#{object.user.screen_name})"
  text = object.text
  created_at = object.created_at.strftime("%Y/%m/%d %H:%M:%S")
  via = object.source.gsub(/<(.+)\">/,"").gsub(/<\/a>/,"")
  arr << "#{@favorite_index} #{put("-", 54)}"
  arr << usera
  text.each_line do |split|
    arr.concat(split_text(split.chomp))
  end
  arr << "#{created_at} #{put(" ", 54 - (get_exact_size(created_at) + get_exact_size(via) + 2))} #{via}"
  arr.push(" ")
  return arr
end

def user_favorite_screen(object)
  opt = {}
  opt["count"] = 200
  favorite = get_favorite(object.id, opt)
  opt["max_id"] = favorite.last.id
  arr = []
  @favorite_temp = {}
  @favorite_index = 0
  arr.push("a")
  loop do
    arr.concat(User_Favorite_Display(favorite.shift))
    break if arr.size > (@y - 17)
  end
  arr.push("Please input 'more' or 'exit'")
  arr.push("You can use '(f|t|r) \#{num}', 'r \#{num} text'")
  loop do
    input = subwindow(arr, arr.size + 5)
    case input
    when /^more$/
      arr = []
      arr.push("【@#{@screen_name}'s Favorites】")
      loop do
        if favorite.size.zero?
          favorite = get_favorite(object.id, opt)
          opt["max_id"] = favorite.last.id
        end
        arr.concat(User_Favorite_Display(favorite.shift))
        break if arr.size > (@y - 17)
      end
      arr.push("Please input 'more' or 'exit'")
      arr.push("You can use '(f|t|r) \#{num}', 'r \#{num} text'")
    when /^f\s(\d+)/
      favorite(@favorite_temp[$1.to_i].id)
    when /^t\s(\d+)/
      retweet(@favorite_temp[$1.to_i].id)
    when /^(r|R|ｒ|Ｒ)(\s*|　*)(\d+)(\s*|　*)(.*)/
      object = @favorite_temp[$3.to_i]
      reply("@#{object.user.screen_name} #{$5}", object.id)
    when /^exit$/
      break
    else
      subwindow(@userConfig[:curses_setting][:mention_error])
    end
  end
end

def user_profile_screen(object)
  arr = []
  friend = friendship(@screen_name, object.screen_name)
  mutual = Mutual(friend.source.following?, friend.source.followed_by?)
  arr.push("【#{object.screen_name} (#{object.name})'s page】")
  arr.push("#{put(" ", 54 - (get_exact_size(@screen_name) + get_exact_size(object.screen_name) + 4))}@#{@screen_name} #{mutual} @#{object.screen_name}")
  arr.push(" ")
  arr.push("discription:")
  arr.concat(split_text(object.description))
  arr.push("location:#{object.location}")
  arr.push("url:#{object.website}")
  arr.push(" ")
  arr.push("tweets:#{object.tweets_count}")
  arr.push("follow:#{object.friends_count}")
  arr.push("follower:#{object.followers_count}")
  arr.push("favorites:#{object.favorites_count}")
  arr.push(" ")
  arr.push("you can user these command.")
  arr.push("'tweet', 'follower', 'following', 'favorite'")
  arr.push("'follow', 'unfollow', 'block', 'unblock'")
  input = subwindow(arr, arr.size + 5)
  case input
  when /tweet/
    user_tweet_screen(object)
  when /^(follower|following)$/
    user_follow_screen(object, $1)
  when /^favorite$/
    user_favorite_screen(object)
  when /^follow$/
    follow(object.screen_name)
    text = text_color("follow success", :cyan)
    print "\n#{text}\n"
  when /^unfollow$/
    unfollow(object.screen_name)
    text = text_color("unfollow success", :cyan)
    print "\n#{text}\n"
  when /^block$/
    block(object.screen_name)
    text = text_color("block success", :cyan)
    print "\n#{text}\n"
  when /^unblock$/
    unblock(object.screen_name)
    text = text_color("unblock success", :cyan)
    print "\n#{text}\n"
  when /^exit$/
  else
    subwindow(@userConfig[:curses_setting][:mention_error])
  end
end

def object_to_user_id(num)
  object = @temp[num]
  case object
  when Twitter::Tweet
    if object.retweet?
      id = object.retweeted_status.user.id
    else
      id = object.user.id
    end
  when Twitter::Streaming::Event
    id = object.target_object.user.id
  when Twitter::Streaming::FriendList
    id = nil
  when Twitter::Streaming::DeletedTweet
    id = nil
  when Twitter::DirectMessage
    id = object.sender.id
  end
  return id
end

def select_user_screen(text=nil)
  if text.nil? || text.size.zero?
    input = subwindow(@userConfig[:curses_setting][:select_user_screen])
  else
    input = text
  end
  case input
  when /^(\d+)(\s*|　*)(.*)/
    id = object_to_user_id($1.to_i)
    unless id.nil?
      user_profile_screen(user_info(id))
    else
      subwindow(@userConfig[:curses_setting][:pakuru_error])
    end
  when /^((@|＠)[A-Za-z0-9_]{1,15})(\s*|　*)(.*)/
    user_profile_screen(user_info($1))
  else
    subwindow(@userConfig[:curses_setting][:select_user_error])
  end
end

def Mention_Display(object)
  @mention_temp[@mention_index+=1] = object
  arr = []
  user = "#{object.user.name} (#{object.user.screen_name})"
  text = object.text
  created_at = object.created_at.strftime("%Y/%m/%d %H:%M:%S")
  via = object.source.gsub(/<(.+)\">/,"").gsub(/<\/a>/,"")
  arr << "#{@mention_index} #{put("-", 54)}"
  arr << user
  text.each_line do |split|
    arr.concat(split_text(split.chomp))
  end
  arr << "#{created_at} #{put(" ", 54 - (get_exact_size(created_at) + get_exact_size(via) + 2))} #{via}"
  arr.push(" ")
  return arr
end

def mention_screen
  opt = {}
  opt["count"] = 200
  mention = get_mention(opt)
  opt["max_id"] = mention.last.id
  arr = []
  @mention_temp = {}
  @mention_index = 0
  arr.push("【@#{@screen_name}'s Mentions】")
  loop do
    arr.concat(Mention_Display(mention.shift))
    break if arr.size > (@y - 15)
  end
  arr.push("Please input 'more' or 'exit'")
  arr.push("You can use '(f|t|r) \#{num}', 'r \#{num} text'")
  loop do
    input = subwindow(arr, arr.size + 5)
    case input
    when /^more$/
      arr = []
      arr.push("【@#{@screen_name}'s Mentions】")
      loop do
        if mention.size.zero?
          mention = get_mention(opt)
          opt["max_id"] = mention.last.id
        end
        arr.concat(Mention_Display(mention.shift))
        break if arr.size > (@y - 15)
      end
      arr.push("Please input 'more' or 'exit'")
      arr.push("You can use '(f|t|r) \#{num}', 'r \#{num} text'")
    when /^f\s(\d+)/
      favorite(@mention_temp[$1.to_i].id)
    when /^t\s(\d+)/
      retweet(@mention_temp[$1.to_i].id)
    when /^(r|R|ｒ|Ｒ)(\s*|　*)(\d+)(\s*|　*)(.*)/
      object = @mention_temp[$3.to_i]
      reply("@#{object.user.screen_name} #{$5}", object.id)
    when /^exit$/
      break
    else
      subwindow(@userConfig[:curses_setting][:mention_error])
    end
  end
end

def control
  loop do
    input = STDIN.noecho(&:gets) #input = STDIN.noecho(&:getch)
    @stream = false
    callback(:command, input.chomp)
    @stream = true
  end
end

on_event(:command) do |input|
  case input
  when /^(r|R|ｒ|Ｒ)(\s*|　*)(.*)/
    reply_screen($3)
  when /^(t|T|ｔ|Ｔ)(\s*|　*)(.*)/
    retweet_screen($3)
  when /^(f|F|ｆ|Ｆ)(\s*|　*)(.*)/
    favorite_screen($3)
  when /^(n|N|ｎ|Ｎ)(\s*|　*)(.*)/
    tweet_screen($3)
  when /^(d|D|ｄ|Ｄ)(\s*|　*)(.*)/
    directmessage_screen($3)
  when /^(p|P|ｐ|ｐ)(\s*|　*)(.*)/
    select_user_screen($3)
  when /^(e|E|ｅ|Ｅ)(\s*|　*)(.*)/
    puts text_color("終了します。")
    exit
  when /^(z|Z|ｚ|Ｚ)(\s*|　*)(.*)/
    print "\e[2J\e[f"
    exit
  when /^(c|C|ｃ|Ｃ)(\s*|　*)(.*)/
    print "\e[2J\e[f"
  when /^(q|Q|ｑ|Ｑ)(\s*|　*)(.*)/
    pid = Process.spawn("#{@command}")
    Process.detach(pid)
    text = text_color("Open new window success.", :cyan)
    print "\n#{text}\n"
  when /^(o|O|ｏ|Ｏ)(\s*|　*)(.*)/
    pakuru_screen($3)
  when /^(m|M|ｍ|Ｍ)(\s*|　*)(.*)/
    mention_screen
  when /^(u|U|ｕ|Ｕ)(\s*|　*)(.*)/
    change_profile_screen
  when /^(\?|？)(\s*|　*)(.*)/
    subwindow(@userConfig[:curses_setting][:help], @userConfig[:curses_setting][:help].size + 2)
  when /^(a|A|ａ|Ａ)(\s*|　*)(.*)/
    @main.kill
    account_setting
    @main = Thread.new{stream}
  when /^(s|S|ｓ|Ｓ)(\s*|　*)(.*)/
    setting
  else
    text = text_color("Command not found")
    print "\n#{text}\n"
  end
end