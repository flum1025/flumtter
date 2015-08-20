# Coding: UTF-8

def Favorite_Display(object, num)
  user = "#{object.target_object.user.name} (#{object.target_object.user.screen_name})"
  tweet = object.target_object.text
  created_at = object.target_object.created_at.strftime("%Y/%m/%d %H:%M:%S")
  via = object.target_object.source.gsub(/<(.+)\">/,"").gsub(/<\/a>/,"")
  source = "<< @#{object.source.screen_name}"
  text = ""
  text << "#{num} #{line(get_exact_size(num.to_s) + 1 + get_exact_size(source))}#{source}\n"
  text << "#{user}#{indent(get_exact_size(user))}\n"
  text << "#{tweet}#{indent((get_exact_size(text) % @x))}\n"
  text << "#{created_at} #{indent(get_exact_size(created_at) + get_exact_size(via) + 2)} #{via}\n\n"
  return text
end

def fav(object)
  num = @temp.key(object)
  if object.target.id == @user_id || object.source.id == @user_id
    text = Favorite_Display(object, num)
    text = text_color(text, :yellow)
    print text
  end
end

on_event(:event) do |object|
  case object.name.to_s
  when "favorite"
    fav(object)
  end
end