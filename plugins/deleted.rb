# Coding: UTF-8

def Deleted_Display(object)
  num = "DELETED"
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

def deleted(object)
  ob = @temp.select{|k, v|
    case v
    when Twitter::Tweet
      v.id == object.id
    end
  }
  key, val = ob.shift
  return if val.nil?
  text = Deleted_Display(val)
  print background_color(text, :blue)
end

on_event(:deletedtweet) do |object|
  deleted(object)
end