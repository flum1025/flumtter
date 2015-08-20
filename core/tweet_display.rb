# Coding: UTF-8

def Tweet_Display(object, num)
  user = "#{object.user.name} (#{object.user.screen_name})"
  tweet = object.text
  created_at = object.created_at.strftime("%Y/%m/%d %H:%M:%S")
  via = object.source.gsub(/<(.+)\">/,"").gsub(/<\/a>/,"")
  text = ""
  text << "#{num} #{line(get_exact_size(num.to_s) + 1)}\n"
  text << "#{user}#{indent(get_exact_size(user))}\n"
  text << "#{tweet}#{indent((get_exact_size(text) % @x))}\n"
  text << "#{created_at} #{indent(get_exact_size(created_at) + get_exact_size(via) + 2)} #{via}\n\n"
  return text
end

def Retweet_Display(object, num)
  user = "#{object.retweeted_status.user.name} (#{object.retweeted_status.user.screen_name})"
  tweet = object.retweeted_status.text
  created_at = object.retweeted_status.created_at.strftime("%Y/%m/%d %H:%M:%S")
  via = object.retweeted_status.source.gsub(/<(.+)\">/,"").gsub(/<\/a>/,"")
  source = "<< @#{object.user.screen_name}"
  text = ""
  text << "#{num} #{line(get_exact_size(num.to_s) + 1 + get_exact_size(source))}#{source}\n"
  text << "#{user}#{indent(get_exact_size(user))}\n"
  text << "#{tweet}#{indent((get_exact_size(text) % @x))}\n"
  text << "#{created_at} #{indent(get_exact_size(created_at) + get_exact_size(via) + 2)} #{via}\n\n"
  return text
end

def timeline(object)
  num = @temp.key(object)
  if object.retweet?
    text = Retweet_Display(object, num)
    text = text_color(text, :blue)
  else
    text = Tweet_Display(object, num)
    text = text_color(text, :cyan) if object.user.id == @user_id
  end
  print text
end

on_event(:tweet) do |object|
  timeline(object)
end