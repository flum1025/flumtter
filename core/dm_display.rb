# Coding: UTF-8

def Directmessage_Display(object, num)
  user = "#{object.sender.name} (#{object.sender.screen_name})"
  dm = object.text
  created_at = object.created_at.strftime("%Y/%m/%d %H:%M:%S")
  text = ""
  text << "#{num} #{line(get_exact_size(num.to_s) + 1)}\n"
  text << "#{user}#{indent(get_exact_size(user))}\n"
  text << "#{dm}#{indent((get_exact_size(text) % @x))}\n"
  text << "#{created_at} #{indent(get_exact_size(created_at) + 1)}\n\n"
  return text
end

def directmessage(object)
  num = @temp.key(object)
  #return if object.sender.id == @user_id
  text = Directmessage_Display(object, num)
  text = text_color(text, :magenta)
  print text
end

on_event(:directmessage) do |object|
  directmessage(object)
end