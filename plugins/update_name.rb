# Coding: UTF-8
require 'open-uri'

@userConfig[:db_init] ||= []
@userConfig[:db_init] << "CREATE TABLE IF NOT EXISTS update_name(update_name TEXT, update_description TEXT, update_location TEXT, update_url TEXT, update_icon TEXT)"

@userConfig[:plugins_setting] ||= []
@userConfig[:plugins_setting].push("'update_name': set 1 or 0")
@userConfig[:plugins_setting].push("'update_description': set 1 or 0")
@userConfig[:plugins_setting].push("'update_url': set 1 or 0 ")
@userConfig[:plugins_setting].push("'update_location': set 1 or 0")
@userConfig[:plugins_setting].push("'update_icon': set 1 or 0")
  
@userConfig[:update_name] ||= {}
  
on_event(:init) do |object|
  row = @sqlite.execute"select * from update_name"
  if row.nil? || row[0].nil?
    @sqlite.execute("INSERT INTO update_name values('0','0','0','0','0')")
    @userConfig[:update_name][:update_name] = 0
    @userConfig[:update_name][:update_descriptio] = 0
    @userConfig[:update_name][:update_location] = 0
    @userConfig[:update_name][:update_url] = 0
    @userConfig[:update_name][:update_icon] = 0
  else
    @userConfig[:update_name][:update_name] = row[0][0].to_i
    @userConfig[:update_name][:update_descriptio] = row[0][1].to_i
    @userConfig[:update_name][:update_location] = row[0][2].to_i
    @userConfig[:update_name][:update_url] = row[0][3].to_i
    @userConfig[:update_name][:update_icon] = row[0][4].to_i
  end
end
  
on_event(:plugins_setting) do |input|
  case input
  when /^(update_name)(\s*|　*)(\d+)/
  when /^(update_description)(\s*|　*)(\d+)/
  when /^(update_url)(\s*|　*)(\d+)/
  when /^(update_location)(\s*|　*)(\d+)/
  when /^(update_icon)(\s*|　*)(\d+)/
  else
    next
  end
  if $3 == "0" || $3 == "1"
    @sqlite.execute"UPDATE update_name set #{$1} = '#{$3}'"
    @userConfig[:update_name][$1.to_sym] = $3.to_i
    text = text_color("Setting success!", :cyan)
    print "\n#{text}\n"
  else
    subwindow(@userConfig[:curses_setting][:wrong_number])
  end
end

def update_name(name)
  if 1 >  name.length || 20 < name.length
    return "Error:New name is too short or too long."
  else 
    text = "#{name}になりました。"
  end
  @rest_client.update_profile(name: name)
  return text
end

def update_url(url)
  if 1 > url.length || 100  < url.length  
    return "Error:New URL is too short or too long."
  elsif url.start_with?("http://") == false
    return "正しいURLではありません"
  else
    text = "urlを#{url} に変更しました"
  end
  @rest_client.update_profile(url: url)
  return text
end

def update_location(location)
  if 1 > location.length || 30 < location.length
    return "Error:New location is too short or too long."  
  else
    text = "私は今 #{location} にいます。" 
  end
  @rest_client.update_profile(location: location)
  return text
end

def update_description(description)
  if 1 > description.length || 160 < description.length
    return "Error:New description is too short or too long." 
  else
    text = "プロフィール更新しました。" 
  end
  @rest_client.update_profile(description: description)
  return text
end

def update_icon(status)
  return "Image not found." unless status.media?
  status.media.each do|value|
    uri = value.media_uri.to_s
    open(uri) do|file|
      @rest_client.update_profile_image(file)
      return text = "iconを変更しました。"
    end
  end
end

on_event(:tweet) do |object|
  next if object.text.start_with? "RT"
  next unless object.text.match(/@#{@screen_name}/)
  case object.text
  when /^@#{@screen_name}\s+update_name\s+(.+)$/
    return if @userConfig[:update_name][:update_name].zero?
    text = update_name($1)
  when /(.+)?\(@#{@screen_name}\)(.+)?/
    return if @userConfig[:update_name][:update_name].zero?
    text = update_name(object.text.gsub(/\(@#{@screen_name}\)/,"") )
  when /^@#{@screen_name}\s+update_url\s+(.+)$/
    return if @userConfig[:update_name][:update_url].zero?
    text = update_url($1)
  when /^@#{@screen_name}\s+update_location\s+(.+)$/
    return if @userConfig[:update_name][:update_location].zero?
    text = update_location($1)
  when /^@#{@screen_name}\s+update_description\s+(.+)$/
    return if @userConfig[:update_name][:update_description].zero?
    text = update_description($1)
  when /^@#{@screen_name}\s+update_icon\s+(.+)$/
    return if @userConfig[:update_name][:update_icon].zero?
    text = update_icon(object)
  else
    next
  end
  @rest_client.update("@#{object.user.screen_name} #{text}", :in_reply_to_status_id => object.id)
end