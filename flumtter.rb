# Coding: UTF-8
require 'twitter'
require 'oauth'
require 'oauth/consumer'
require 'io/console'
#require 'readline'
require 'curses'
require 'sqlite3'
require 'open-uri'

$SourcePath = File.expand_path('../', __FILE__)
$TokenFile = "#{$SourcePath}/token.db"

class Flumtter
  def initialize(num=nil)
    setting(num)
    config
    @x = `tput cols`.to_i
    @y = `tput lines`.to_i
    @data =[]
    @my_user_id = @rest_client.user.id
    @orig_name, @screen_name = [:name, :screen_name].map{|x| @rest_client.user.send(x) }
    @q = false
    #@command = "open -a 'Terminal' '#{$SourcePath}'"
    SQLite3::Database.open($TokenFile) do |db|
      row = db.execute"select replies from setting"
      if row == nil || row[0] == nil
        @option = {}
      else
        if row[0][0] == "1"
          @option = {:replies => 'all'}
        else
          @option = {}
        end
      end
      row = db.execute"select * from func"
      @update_name = row[0][0].to_i
      @update_description = row[0][1].to_i
      @update_location = row[0][2].to_i
      @update_url = row[0][3].to_i
      @update_icon = row[0][4].to_i
      row = db.execute"select terminal from other"
      unless row == nil || row[0] == nil
        @command = row[0][0]
      else
        @command = ""
      end
    end
  rescue
    error
  end
  
  def config
    @rest_client = Twitter::REST::Client.new do |config|
      config.consumer_key        = $consumer_key
      config.consumer_secret     = $consumer_secret
      config.access_token        = $access_token
      config.access_token_secret = $access_secret
    end
    @stream_client = Twitter::Streaming::Client.new do |config|
      config.consumer_key        = $consumer_key
      config.consumer_secret     = $consumer_secret
      config.access_token        = $access_token
      config.access_token_secret = $access_secret
    end
  end
  
  def setting(num=nil)
    oauth = Oauth.new
    tokens = oauth.oauth_load
    if num == nil
      arr = []
      arr.push("【Setting】")
      arr.push("Please set your account number.")
      i = 0
      tokens.each do |token|
        client = Twitter::REST::Client.new do |config|
          config.consumer_key        = token[0]
          config.consumer_secret     = token[1]
          config.access_token        = token[2]
          config.access_token_secret = token[3]
        end
        token_name = [:name, :screen_name].map{|x| client.user.send(x) } rescue "broken token or TooManyRequests"
        arr.push("#{i}:#{token_name}")
        i += 1
      end
      arr.push("Please input 'regist' when you want to regist new account.")
      text = subwindow(arr, tokens.size + 10)
    else
      text = num
    end
    if text.match(/^(\d+)/)
      if tokens[$1.to_i] == nil
        arr = []
        arr.push("wrong number!!!!!!!")
        arr.push("Please re-setting.")
        arr.push("Please enter...")
        subwindow(arr, tokens.size + 5)
        setting
      else
        $consumer_key = tokens[$1.to_i][0]
        $consumer_secret = tokens[$1.to_i][1]
        $access_token = tokens[$1.to_i][2]
        $access_secret = tokens[$1.to_i][3]
      end
    elsif text == "regist"
      oauth.oauth_first
      setting
    else
      arr = []
      arr.push("Command not found")
      arr.push("Please re-setting.")
      arr.push("Please enter...")
      subwindow(arr, tokens.size + 5)
      setting
    end
  rescue
    error
  end
  
  def red(text)
    return "\e[31m#{text}\e[0m"
  end
  
  def blue(text)
    return "\e[34m#{text}\e[0m"
  end
  
  def green(text)
    return "\e[32m#{text}\e[0m"
  end
  
  def magenta(text)
    return "\e[35m#{text}\e[0m"
  end
  
  def cyan(text)
    return "\e[36m#{text}\e[0m"
  end
  
  def get_exact_size(string)
    string.each_char.map{|c| c.bytesize == 1 ? 1 : 2}.reduce(0, &:+)
  end
  
  def line(num=nil)
    x = @x
    x = x - num unless num == nil
    str = ""
    x.times do |i|
      str += "-"
    end
    return str
  end
  
  def put(char, num)
    text = ""
    num.times{|i|
      text << char
    }
    return text
  end
  
  def clean(num=nil)
    y = @y
    y = y - num unless num == nil
    str = ""
    y.times do |i|
      str = "#{str}\n"
    end
    return str
  end
  
  def indent(num=nil)
    x = @x
    x = x - num unless num == nil
    str = nil
    x.times do |i|
      str = "#{str} "
    end
    return str
  end

  def TL(status, source_user=nil)
    @data.push(status.id)
    num = @data.size - 1
    user = "#{status.user.name} (#{status.user.screen_name})"
    text = status.text
    created_at = status.created_at.strftime("%Y/%m/%d %H:%M:%S")
    via = status.source.gsub(/<(.+)\">/,"").gsub(/<\/a>/,"")
    if source_user == nil
      li0 = "#{num} #{line(get_exact_size(num.to_s) + 1)}"
    else
      source = "<< @#{source_user}" unless source_user == nil
      li0 = "#{num} #{line(get_exact_size(num.to_s) + 1 + get_exact_size(source))}#{source}"
    end
    li1 = "#{user}#{indent(get_exact_size(user))}"
    li2 = "#{text}#{indent((get_exact_size(text) % @x))}"
    li3 = "#{created_at} #{indent(get_exact_size(created_at) + get_exact_size(via) + 2)} #{via}"
    text = "#{li0}\n#{li1}\n#{li2}\n#{li3}\n\n"
    return text
  end
  
  def timeline(status)
    if status.retweet?
      text = TL(status.retweeted_status, status.user.screen_name)
      text = blue(text)
      print text
    else
      text = TL(status)
      text = green(text) if status.user.id == @my_user_id
      print text
    end
  end
  
  def event(status)
    case status.name.to_s
    when "follow"
    when "unfollow"
    when "favorite"
      if status.target.id == @my_user_id || status.source.id == @my_user_id
        object = status.target_object
        text = TL(object, status.source.screen_name)
        text = cyan(text)
        print text
      end
    when "unfavorite"
    end
  end

  def deletedtweet(status)
    
  end
  
  def DM(status)
    @data.push(status.sender.id)
    num = @data.size - 1
    user = "#{status.sender.name} (#{status.sender.screen_name})"
    text = status.text
    created_at = status.created_at.strftime("%Y/%m/%d %H:%M:%S")
    li0 = "#{num} #{line(get_exact_size(num.to_s) + 1)}"
    li1 = "#{user}#{indent(get_exact_size(user))}"
    li2 = "#{text}#{indent((get_exact_size(text) % @x))}"
    li3 = "#{created_at} #{indent(get_exact_size(created_at) + 1)}"
    text = "#{li0}\n#{li1}\n#{li2}\n#{li3}\n\n"
    return text
  end
  
  def directmessage(status)
    return if status.sender.id == @my_user_id
    text = DM(status)
    text = magenta(text)
    print text
  end
  
  def name(name)
    if 1 >  name.length || 20 < name.length
      text = "Error:New name is too short or too long."
      return text
    else 
      text = "#{name}になりました。"
    end
    @rest_client.update_profile(name: name)
    return text
  end

  def url(url)
    if 1 > url.length || 100  < url.length  
      text = "Error:New URL is too short or too long."
      return text
    elsif url.start_with?("http://") == false
      text = "正しいURLではありません"
      return text
    else
      text = "urlを#{url} に変更しました"
    end
    @rest_client.update_profile(url: url)
    return text
  end
  
  def location(location)
    if 1 > location.length || 30 < location.length
      text = "Error:New location is too short or too long."  
      return text
    else
      text = "私は今 #{location} にいます。" 
    end
    @rest_client.update_profile(location: location)
    return text
  end
  
  def description(description)
    if 1 > description.length || 160 < description.length
      text = "Error:New description is too short or too long." 
      return text
    else
      text = "プロフィール更新しました。" 
    end
    @rest_client.update_profile(description: description)
    return text
  end
  
  def update_icon(status)
    return text = "Image not found." unless status.media?
      status.media.each do|value|
        uri = value.media_uri.to_s
        open(uri) do|file|
          @rest_client.update_profile_image(file)
          return text = "iconを変更しました。"
        end
      end
  end
  
  def func(status)
    if status.text.match(/^@#{@screen_name}\s+update_name\s+(.+)$/)
      return if @update_name == 0
      name = $1  
      text = name(name)
    elsif status.text.match(/(.+)?\(@#{@screen_name}\)(.+)?/)  
      return if @update_name == 0
      name = status.text.gsub(/\(@#{@screen_name}\)/,"")     
      text = name(name)
    elsif status.text.match(/^@#{@screen_name}\s+update_url\s+(.+)$/)
      return if @update_url == 0
      url = $1
      text = url(url)
    elsif status.text.match(/^@#{@screen_name}\s+update_location\s+(.+)$/)
      return if @update_location == 0
      location = $1
      text = location(location)
    elsif status.text.match(/^@#{@screen_name}\s+update_description\s+(.+)$/)
      return if @update_description == 0
      description = $1
      text = description(description)
    elsif status.text.match(/^@#{@screen_name}\s+update_icon\s+(.+)$/)
      return if @update_icon == 0
      icon = $1
      text = update_icon(status)
    else
      return
    end
    @rest_client.update("#{text} by @#{status.user.screen_name}", :in_reply_to_status_id => status.id)
  end
  
  def stream
    puts "@#{@screen_name}'s stream_start!"
    @stream_client.user(@option) do |object|
      loop do
        if @q == true
          sleep(1)
        elsif @q == "kill"
          @q = false
          return
        else
          break
        end
      end
      @x = `tput cols`.to_i
      @y = `tput lines`.to_i
      begin
        case object
        when Twitter::Tweet
          timeline(object)
          unless object.text.start_with? "RT"
            func(object)
          end
        when Twitter::Streaming::Event
          event(object)
        when Twitter::Streaming::FriendList
          
        when Twitter::Streaming::DeletedTweet
          deletedtweet(object)
        when Twitter::DirectMessage
          directmessage(object)
        end
      rescue
        error
      end
    end
  end
  
  def reply(num, text)
    status = @rest_client.status(@data[num]).user.screen_name
    @rest_client.update("@#{status} #{text}", :in_reply_to_status_id => @data[num])
  end
  
  def tweet(text)
    @rest_client.update(text)
  end
  
  def retweet(num)
    @rest_client.retweet(@data[num])
  end
  
  def fav(num)
    @rest_client.favorite(@data[num])
  end
  
  def DM_i(num, text)
    @rest_client.create_direct_message(@data[num], text)
  end
  
  def DM_s(user, text)
    @rest_client.create_direct_message(user, text)
  end
  
  def subwindow(texts, high=10, width=60)
    x = 2
    y = 2
    s = Curses.stdscr.subwin(high, width, x, y)
    s.clear
    s.clrtoeol
    s.box(?|, ?-, ?*)
    texts.each do |text|
      s.setpos(x, y)
      s.addstr(text)
      s.addstr("\n")
      s.refresh
      x += 1
    end
    s.setpos(x, y)
    input = s.getstr
    input.encode!('UTF-16', 'UTF-8', :invalid => :replace, :replace => '')
    input.encode!('UTF-8', 'UTF-16')
    s.clear
    s.close
    Curses.close_screen
    return input
  end
  
  def extract_num(text)
    
  end
  
  def extract_screen_name(text)
    
  end
  
  def extract(text)
    state = true
    tag = nil
    data = []
    case text
    when /^(\d+|[０-９]+)(\s*|　*)(.*)/
      unless $3 == nil
        data.push($1)
        data.push($3)
        tag = "num"
      else
        state = false
        data = "Please input tweet content."
      end
    when /^((@|＠)[A-Za-z0-9_]{1,15})(\s*|　*)(.*)/
      unless $4 == nil
        data.push($1)
        data.push($4)
        tag = "screen_name"
      else
        state = false
        data = "Please input tweet content."
      end
    else
      state = false
      data = red("Please input (ID or Screen_name) and tweet content.")     
    end
    return state, tag, data
  end
  
  def flumtter_setting
    arr.push("【flumtter setting】")
    arr.push("Please input item and value")
    arr.push("''")
  end
  
  def stream_setting
    arr = []
    arr.push("【Stream setting】")
    arr.push("Please input item name and value")
    arr.push("'replies': set 1 or 0  #Current setting is '#{@option}'")
    arr.push("syntax: 'replies 1'")
    arr.push("Please input...")
    text = subwindow(arr)
    if text.match(/^replies(\s*|　*)(\d+)/)
      if $2 == "0" || $2 == "1"
        SQLite3::Database.open($TokenFile) do |db|
          db.execute"UPDATE setting set replies = '#{$2}'"
        end
        text = "Setting success!"
        text = cyan(text)
        print "\n#{text}\n"
      else
        arr = []
        arr.push("wrong number!!!!!!!")
        arr.push("Please re-setting.")
        arr.push("Please enter...")
        subwindow(arr)
        stream_setting
      end
    elsif text == "exit"
    else
      arr = []
      arr.push("Command not found")
      arr.push("Please re-setting.")
      arr.push("Please enter...")
      subwindow(arr)
      stream_setting
    end
  end
  
  def plugins_setting
    arr = []
    arr.push("【Plugins setting】")
    arr.push("Please input item name and value")
    arr.push(" ")
    arr.push("'update_name': set 1 or 0  #Current value is '#{@update_name}'")
    arr.push("'update_description': set 1 or 0  #Current value is '#{@update_description}'")
    arr.push("'update_url': set 1 or 0  #Current value is '#{@update_url}'")
    arr.push("'update_location': set 1 or 0  #Current value is '#{@update_location}'")
    arr.push("'update_icon': set 1 or 0  #Current value is '#{@update_icon}'")
    arr.push(" ")
    arr.push("syntax: 'update_name 1'")
    arr.push("Please input...")
    text = subwindow(arr, arr.push.size + 5)
    case text
    when /^(update_name)(\s*|　*)(\d+)/
      if $3 == "0" || $3 == "1"
        SQLite3::Database.open($TokenFile) do |db|
          db.execute"UPDATE func set #{$1} = '#{$3}'"
        end
        @update_name = $3.to_i
        text = "Setting success!"
        text = cyan(text)
        print "\n#{text}\n"
      else
        arr = []
        arr.push("wrong number!!!!!!!")
        arr.push("Please re-setting.")
        arr.push("Please enter...")
        subwindow(arr)
        plugins_setting
      end
    when /^(update_description)(\s*|　*)(\d+)/
      if $3 == "0" || $3 == "1"
        SQLite3::Database.open($TokenFile) do |db|
          db.execute"UPDATE func set #{$1} = '#{$3}'"
        end
        @update_description = $3.to_i
        text = "Setting success!"
        text = cyan(text)
        print "\n#{text}\n"
      else
        arr = []
        arr.push("wrong number!!!!!!!")
        arr.push("Please re-setting.")
        arr.push("Please enter...")
        subwindow(arr)
        plugins_setting
      end
    when /^(update_url)(\s*|　*)(\d+)/
      if $3 == "0" || $3 == "1"
        SQLite3::Database.open($TokenFile) do |db|
          db.execute"UPDATE func set #{$1} = '#{$3}'"
        end
        @update_url = $3.to_i
        text = "Setting success!"
        text = cyan(text)
        print "\n#{text}\n"
      else
        arr = []
        arr.push("wrong number!!!!!!!")
        arr.push("Please re-setting.")
        arr.push("Please enter...")
        subwindow(arr)
        plugins_setting
      end
    when /^(update_location)(\s*|　*)(\d+)/
      if $3 == "0" || $3 == "1"
        SQLite3::Database.open($TokenFile) do |db|
          db.execute"UPDATE func set #{$1} = '#{$3}'"
        end
        @update_location = $3.to_i
        text = "Setting success!"
        text = cyan(text)
        print "\n#{text}\n"
      else
        arr = []
        arr.push("wrong number!!!!!!!")
        arr.push("Please re-setting.")
        arr.push("Please enter...")
        subwindow(arr)
        plugins_setting
      end
    when /^(update_icon)(\s*|　*)(\d+)/
      if $3 == "0" || $3 == "1"
        SQLite3::Database.open($TokenFile) do |db|
          db.execute"UPDATE func set #{$1} = '#{$3}'"
        end
        @update_icon = $3.to_i
        text = "Setting success!"
        text = cyan(text)
        print "\n#{text}\n"
      else
        arr = []
        arr.push("wrong number!!!!!!!")
        arr.push("Please re-setting.")
        arr.push("Please enter...")
        subwindow(arr)
        plugins_setting
      end
    when /^exit$/
    else
      arr = []
      arr.push("Command not found")
      arr.push("Please re-setting.")
      arr.push("Please enter...")
      subwindow(arr)
      plugins_setting
    end
  end
  
  def account_setting
    oauth = Oauth.new
    tokens = oauth.oauth_load
    arr = []
    arr.push("【Account setting】")
    arr.push("Please select the account you want to delete.")
    i = 0
    tokens.each do |token|
      client = Twitter::REST::Client.new do |config|
        config.consumer_key        = token[0]
        config.consumer_secret     = token[1]
        config.access_token        = token[2]
        config.access_token_secret = token[3]
      end
      token_name = [:name, :screen_name].map{|x| client.user.send(x) } rescue "broken token or TooManyRequests"
      arr.push("#{i}:#{token_name}")
      i += 1
    end
    arr.push("Please input 'exit' you want to back.")
    text = subwindow(arr, tokens.size + 10)
    if text.match(/^(\d+)/)
      if tokens[$1.to_i] == nil
        arr = []
        arr.push("wrong number!!!!!!!")
        arr.push("Please re-setting.")
        arr.push("Please enter...")
        subwindow(arr, tokens.size + 5)
        account_setting
      else
        id = $1.to_i + 1
        SQLite3::Database.open($TokenFile) do |db|
          db.execute("DELETE FROM token WHERE ROWID = #{id}")
        end
        text = "Delete account is success!"
        text = cyan(text)
        print "\n#{text}\n"
      end
    elsif text == "exit"
    else
      arr = []
      arr.push("Command not found")
      arr.push("Please re-setting.")
      arr.push("Please enter...")
      subwindow(arr, tokens.size + 5)
      account_setting
    end
  end
  
  def other_setting
    arr = []
    arr.push("【Other setting】")
    arr.push("Please input item name and value")
    arr.push("terminal start up command:")
    arr.push(" #Current setting is '#{@command}'")
    arr.push(" ")
    arr.push("'#path' is converted source folder path.")
    arr.push("syntax: 'terminal \#{command}'")
    arr.push(" ")
    arr.push("Command Example:")
    arr.push("mac: \"open -a 'Terminal' '#path'\"")
    arr.push("gnome: \"gnome-terminal -e 'ruby #path/flumtter.rb'\"")
    arr.push("lxterminal: \"lxterminal -e 'ruby #path/flumtter.rb'\"")
    arr.push("Please input...")
    text = subwindow(arr, arr.push.size + 5)
    case text
    when /^terminal\s(.+)/
      com = $1
      com = com.gsub(/#path/, $SourcePath)
      com = com.gsub(/'/, '"')
      SQLite3::Database.open($TokenFile) do |db|
        db.execute"UPDATE other set terminal = '#{com}'"
      end
      @command = com
      text = "Set command is success!"
      text = cyan(text)
      print "\n#{text}\n"
    when /^exit$/
    else
      arr = []
      arr.push("Command not found")
      arr.push("Please re-setting.")
      arr.push("Please enter...")
      subwindow(arr, arr.size + 5)
      other_setting
    end
  end 
  
  def control
    loop do
      input = STDIN.noecho(&:gets)
      #input = STDIN.noecho(&:getch)
      @q = true
      case input.chomp
      when /^(r|R|ｒ|Ｒ)(\s*|　*)(.*)/
        if $3.size == 0
          arr = []
          arr.push("【Reply screen】")
          arr.push("Please input target (num or screen_name) and tweet content.")
          arr.push("Syntax: '[num|screen_name] abcde'")
          arr.push("Example: '3 abcde' or '@null abcde'")
          arr.push("please input...")
          text = subwindow(arr)
          state, tag, re = extract(text)
        else
          state, tag, re = extract($3)
        end
        if state
          if tag == "num"
            reply(re[0].to_i, re[1])
          elsif tag == "screen_name"
            tweet("#{re[0]} #{re[1]}")
          end
        else
          print "\n#{re}\n"
        end
      when /^(t|T|ｔ|Ｔ)(\s*|　*)(.*)/
        if $3.size == 0
          arr = []
          arr.push("【Retweet screen】")
          arr.push("Please input target num.")
          arr.push("Syntax: '[num]'")
          arr.push("Example: 1")
          arr.push("please input...")
          text = subwindow(arr)
          if text.match(/^\d+/)
            retweet(text.to_i)
          else
            text = red("please input number only")
            print "\n#{text}\n"
          end
        else
          if $3.match(/^(\d+)/)
            retweet($1.to_i)
          else
            text = red("please input number only")
            print "\n#{text}\n"
          end
        end
      when /^(f|F|ｆ|Ｆ)(\s*|　*)(.*)/
        if $3.size == 0
          arr = []
          arr.push("【Favorite screen】")
          arr.push("Please input target num.")
          arr.push("Syntax: '[num]'")
          arr.push("Example: 1")
          arr.push("please input...")
          text = subwindow(arr)
          if text.match(/^(\d+)/)
            fav($1.to_i)
            text = "favorite success"
            text = cyan(text)
            print "\n#{text}\n"
          else
            text = red("please input number only")
            print "\n#{text}\n"
          end
        else
          if $3.match(/^(\d+)/)
            fav($1.to_i)
            text = "favorite success"
            text = cyan(text)
            print "\n#{text}\n"
          else
            text = red("please input number only")
            print "\n#{text}\n"
          end
        end
      when /^(n|N|ｎ|Ｎ)(\s*|　*)(.*)/
        if $3.size == 0
          arr = []
          arr.push("【Tweet screen】")
          arr.push("Please input tweet content.")
          arr.push("Syntax: 'abcde'")
          arr.push("Example: abcde")
          arr.push("please input...")
          text = subwindow(arr)
          unless text.size == 0
            tweet(text)
          else
            text = red("please input one or more word.")
            print "\n#{text}\n"
          end
        else
          tweet($3)
        end
      when /^(d|D|ｄ|Ｄ)(\s*|　*)(.*)/
        if $3.size == 0
          arr = []
          arr.push("【Direct message screen】")
          arr.push("Please input target (num or screen_name) and DM content.")
          arr.push("Syntax: '[num|screen_name] abcde'")
          arr.push("Example: '3 abcde' or '@null abcde'")
          arr.push("please input...")
          text = subwindow(arr)
          state, tag, re = extract(text)
        else
          state, tag, re = extract($3)
        end
        if state
          if tag == "num"
            begin
              DM_i(re[0].to_i, re[1])
            rescue Twitter::Error::NotFound
              status = @rest_client.status(@data[re[0].to_i]).user.screen_name
              DM_s(status, re[1])
            end
          elsif tag == "screen_name"
            DM_s(re[0], re[1])
          end
        else
          print "\n#{re}\n"
        end
      when /^(p|P|ｐ|ｐ)(\s*|　*)(.*)/
        if $3.size == 0
          arr = []
          arr.push("【User profile screen】")
          arr.push("Please input target (num or screen_name).")
          arr.push("Syntax: '[num|screen_name]'")
          arr.push("Example: '3' or '@null'")
          arr.push("please input...")
          text = subwindow(arr)
          state, tag, re = extract(text)
        else
          state, tag, re = extract($3)
        end
        if state
          if tag == "num"
            status = @rest_client.status(@data[re[0].to_i]).user.id
            user = @rest_client.user(status)
          elsif tag == "screen_name"
            user = @rest_client.user(re[0])
          end
          arr2 = []
          arr2.push("【#{user.screen_name} (#{user.name})'s page】")
          friend = @rest_client.friendship(@screen_name, user.screen_name)
          if friend.source.following?
            f = ">"
          else
            f = "/"
          end
          if friend.source.followed_by?
            fb = "<"
          else
            fb = "/"
          end
          arr2.push("#{put(" ", 54 - (get_exact_size(@screen_name) + get_exact_size(user.screen_name) + 4))}@#{@screen_name} #{fb}=#{f} @#{user.screen_name}")
          arr2.push(" ")
          arr2.push("discription:#{user.description}")
          arr2.push("location:#{user.location}")
          arr2.push("url:#{user.website}")
          arr2.push(" ")
          arr2.push("tweets:#{user.tweets_count}")
          arr2.push("follow:#{user.friends_count}")
          arr2.push("follower:#{user.followers_count}")
          arr2.push("favorites:#{user.favorites_count}")
          arr2.push(" ")
          arr2.push("you can user these command.")
          arr2.push("'tweet', 'follower', 'following', 'favorite'")
          arr2.push("'follow', 'unfollow', 'block', 'unblock'")
          arr2.push("Please input command or enter...")
          text = subwindow(arr2, arr2.size + 5)
          unless text.size == 0
            case text
            when /tweet/
              max_id = nil
              loop do
                user_data = []
                arr = []
                arr.push("【#{user.screen_name} (#{user.name})'s tweets】")
                opt = {}
                opt["count"] = 50
                opt["max_id"] = max_id unless max_id == nil
                @rest_client.user_timeline("#{user.screen_name}", opt).each do |status|
                  user_data.push(status.id)
                  num = user_data.size - 1
                  user_i = "#{status.user.name} (#{status.user.screen_name})"
                  text = status.text
                  created_at = status.created_at.strftime("%Y/%m/%d %H:%M:%S")
                  via = status.source.gsub(/<(.+)\">/,"").gsub(/<\/a>/,"")
                  li0 = "#{num} #{put("-", 54)}"
                  li1 = "#{user_i}"
                  li2 = "#{text}"
                  li3 = "#{created_at} #{put(" ", 54 - (get_exact_size(created_at) + get_exact_size(via) + 2))} #{via}"
                  arr.push(li0)
                  arr.push(li1)
                  li2.each_line do |split|
                    arr.push(split.chomp)
                  end
                  arr.push(li3)
                  arr.push(" ")
                  break if arr.size > (@y - 15)
                end
                arr.push("Please input 'more' or 'exit'")
                arr.push("You can use '(f|t|r) \#{num}', 'r \#{num} text'")
                text = subwindow(arr, arr.size + 5)
                case text
                when /^more$/
                  max_id = user_data.last
                when /^f\s(\d+)/
                  @rest_client.favorite(user_data[$1.to_i])
                when /^t\s(\d+)/
                  @rest_client.retweet(user_data[$1.to_i])
                when /^(r|R|ｒ|Ｒ)(\s*|　*)(\d+)(\s*|　*)(.+)/
                  status = @rest_client.status(user_data[$3.to_i]).user.screen_name
                  @rest_client.update("@#{status} #{$5}", :in_reply_to_status_id => user_data[$3.to_i])
                when /^exit$/
                  break
                else
                  text = red("Command not found")
                  print "\n#{text}\n"
                end
              end
            when /^(follower|following)$/
              if $1 == "follower"
                id = @rest_client.follower_ids(user.screen_name).to_a
              elsif $1 == "following"
                id = @rest_client.friend_ids(user.screen_name).to_a
              end
              users = []
              @rest_client.users(id).each do |status|
                users.push(status.screen_name)
              end
              s = 0
              loop do
                arr = []
                for i in s..(s + @y - 15)
                  arr.push(users[i]) rescue break
                end
                arr.push("Please input 'more' or 'exit...'")
                text = subwindow(arr, arr.size + 5)
                case text
                when /^more$/
                  s = s + @y -15
                when /^exit$/
                  break
                else
                  text = red("Command not found")
                  print "\n#{text}\n"
                end
              end
            when /^favorite$/
              max_id = nil
              loop do
                user_data = []
                arr = []
                arr.push("【#{user.screen_name} (#{user.name})'s favorites")
                opt = {}
                opt["count"] = 50
                opt["max_id"] = max_id unless max_id == nil
                @rest_client.favorites(user.screen_name, opt).each do |status|
                  user_data.push(status.id)
                  num = user_data.size - 1
                  user_i = "#{status.user.name} (#{status.user.screen_name})"
                  text = status.text
                  created_at = status.created_at.strftime("%Y/%m/%d %H:%M:%S")
                  via = status.source.gsub(/<(.+)\">/,"").gsub(/<\/a>/,"")
                  li0 = "#{num} #{put("-", 54)}"
                  li1 = "#{user_i}"
                  li2 = "#{text}"
                  li3 = "#{created_at} #{put(" ", 54 - (get_exact_size(created_at) + get_exact_size(via) + 2))} #{via}"
                  arr.push(li0)
                  arr.push(li1)
                  li2.each_line do |split|
                    arr.push(split.chomp)
                  end
                  arr.push(li3)
                  arr.push(" ")
                  break if arr.size > (@y - 15)
                end
                arr.push("Please input 'more' or 'exit'")
                arr.push("You can use '(f|t|r) \#{num}', 'r \#{num} text'")
                text = subwindow(arr, arr.size + 5)
                case text
                when /^more$/
                  max_id = user_data.last
                when /^f\s(\d+)/
                  @rest_client.favorite(user_data[$1.to_i])
                when /^t\s(\d+)/
                  @rest_client.retweet(user_data[$1.to_i])
                when /^(r|R|ｒ|Ｒ)(\s*|　*)(\d+)(\s*|　*)(.+)/
                  status = @rest_client.status(user_data[$3.to_i]).user.screen_name
                  @rest_client.update("@#{status} #{$5}", :in_reply_to_status_id => user_data[$3.to_i])
                when /^exit$/
                  break
                else
                  text = red("Command not found")
                  print "\n#{text}\n"
                end
              end        
            when /^follow$/
              @rest_client.follow(user.screen_name)
              text = "follow success"
              text = cyan(text)
              print "\n#{text}\n"
            when /^unfollow$/
              @rest_client.unfollow(user.screen_name)
              text = "unfollow success"
              text = cyan(text)
              print "\n#{text}\n"
            when /^block$/
              @rest_client.block(user.screen_name)
              text = "block success"
              text = cyan(text)
              print "\n#{text}\n"
            when /^unblock$/
              @rest_client.unblock(user.screen_name)
              text = "unblock success"
              text = cyan(text)
              print "\n#{text}\n"
            when /^exit$/
            else
              text = red("Command not found")
              print "\n#{text}\n"
            end
          end
        else
          print "\n#{text}\n"
        end
      when /^(e|E|ｅ|Ｅ)(\s*|　*)(.*)/
        puts "終了します。"
        exit
      when /^(z|Z|ｚ|Ｚ)(\s*|　*)(.*)/
        puts "強制終了します。"
        print "\e[2J\e[f"
        exit
      when /^(c|C|ｃ|Ｃ)(\s*|　*)(.*)/
        print "\e[2J\e[f"
      when /^(q|Q|ｑ|Ｑ)(\s*|　*)(.*)/
        pid = Process.spawn("#{@command}")
        Process.detach(pid)
        text = "Open new window success."
        text = cyan(text)
        print "\n#{text}\n"
      when /^(o|O|ｏ|Ｏ)(\s*|　*)(.*)/
        if $3.size == 0
          arr = []
          arr.push("【Paku-ru screen】")
          arr.push("Please input target num.")
          arr.push("Syntax: '[num]'")
          arr.push("Example: 1")
          arr.push("please input...")
          text = subwindow(arr)
          if text.match(/^(\d+)/)
            text = @rest_client.status(@data[$1.to_i]).text
            @rest_client.update(text)
          else
            text = red("please input number only")
            print "\n#{text}\n"
          end
        else
          if $3.match(/^(\d+)/)
            text = @rest_client.status(@data[$1.to_i]).text
            @rest_client.update(text)
          else
            text = red("please input number only")
            print "\n#{text}\n"
          end
        end
      when /^(m|M|ｍ|Ｍ)(\s*|　*)(.*)/
        max_id = nil
        loop do
          user_data = []
          arr = []
          arr.push("【@#{@screen_name}'s Mentions】")
          opt = {}
          opt["count"] = 50
          opt["max_id"] = max_id unless max_id == nil
          @rest_client.mentions(opt).each do |status|
            user_data.push(status.id)
            num = user_data.size - 1
            user_i = "#{status.user.name} (#{status.user.screen_name})"
            text = status.text
            created_at = status.created_at.strftime("%Y/%m/%d %H:%M:%S")
            via = status.source.gsub(/<(.+)\">/,"").gsub(/<\/a>/,"")
            li0 = "#{num} #{put("-", 54)}"
            li1 = "#{user_i}"
            li2 = "#{text}"
            li3 = "#{created_at} #{put(" ", 54 - (get_exact_size(created_at) + get_exact_size(via) + 2))} #{via}"
            arr.push(li0)
            arr.push(li1)
            li2.each_line do |split|
              arr.push(split.chomp)
            end
            arr.push(li3)
            arr.push(" ")
            break if arr.size > (@y - 15)
          end
          arr.push("Please input 'more' or 'exit'")
          arr.push("You can use '(f|t|r) \#{num}', 'r \#{num} text'")
          text = subwindow(arr, arr.size + 5)
          case text
          when /^more$/
            max_id = user_data.last
          when /^f\s(\d+)/
            @rest_client.favorite(user_data[$1.to_i])
          when /^t\s(\d+)/
            @rest_client.retweet(user_data[$1.to_i])
          when /^(r|R|ｒ|Ｒ)(\s*|　*)(\d+)(\s*|　*)(.+)/
            status = @rest_client.status(user_data[$3.to_i]).user.screen_name
            @rest_client.update("@#{status} #{$5}", :in_reply_to_status_id => user_data[$3.to_i])
          when /^exit$/
            break
          else
            text = red("Command not found")
            print "\n#{text}\n"
          end
        end
      when /^(u|U|ｕ|Ｕ)(\s*|　*)(.*)/
        user = @rest_client.user(@screen_name)
        arr = []
        arr.push("【Change profile】")
        arr.push("Plese select item you want to chenge with new profile.")
        arr.push(":name")
        arr.push("   #Current_value:#{user.name}")
        arr.push(":description")
        arr.push("   #Current_value:#{user.description}")
        arr.push(":url")
        arr.push("   #Current_value:#{user.website}")
        arr.push(":location")
        arr.push("   #Current_value:#{user.location}")
        arr.push(" ")
        arr.push("Syntax: 'name abcde'")
        arr.push("Please input...")
        text = subwindow(arr, arr.size + 5)
        case text
        when /^name\s(.*)/
          unless 1 > $1.length || 20 < $1.length
            @rest_client.update_profile(name: $1)
            text = cyan("Change name Success.")
            print "\n#{text}\n"
          else
            text = red("New name is too short or too long.")
            print "\n#{text}\n"
          end
        when /^description\s(.*)/
          unless 1 > $1.length || 160 < $1.length
            @rest_client.update_profile(description: $1)
            text = cyan("Change description Success.")
            print "\n#{text}\n"
          else
            text = red("New description is too short or too long.")
            print "\n#{text}\n"
          end
        when /^url\s(.*)/
          if 1 > $1.length || 100 < $1.length
            text = red("New url is too short or too long.")
            print "\n#{text}\n"
          elsif $1.start_with?("http://") == false
            text = red("New url is wrong.")
            print "\n#{text}\n"
          else
            @rest_client.update_profile(url: $1)
            text = cyan("Change url Success.")
            print "\n#{text}\n"
          end
        when /^location\s(.*)/
          unless 1 > $1.length || 30 < $1.length
            @rest_client.update_profile(location: $1)
            text = cyan("Change location Success.")
            print "\n#{text}\n"
          else
            text = red("New location is too short or too long.")
            print "\n#{text}\n"
          end
        else
          text = red("Command not found")
          print "\n#{text}\n"
        end
      when /^(\?|？)(\s*|　*)(.*)/
        arr = []
        arr.push("【Keyboard shortcuts】")
        arr.push("r:Reply")
        arr.push("t:Retweet")
        arr.push("f:Favorite")
        arr.push("n:New tweet")
        arr.push("d:Direct message")
        arr.push("p:User profile")
        arr.push("m:Mention")
        arr.push("o:Paku-ru")
        arr.push("u:Change profile")
        arr.push("e:Exit")
        arr.push("c:Clear the terminal screen")
        arr.push("z:Forced termination and clear the terminal screen")
        arr.push("s:Setting menu")
        arr.push("a:Account change")
        arr.push("?:This menu")
        arr.push("q:Open new terminal")
        arr.push("\n")
        arr.push("For more information, please see the following Home page.")
        arr.push("http://flum.pw/twitter/index.php?page=flumtter")
        arr.push("\n")
        arr.push("This software is released under the MIT License")
        arr.push("Copyright © @flum_ 2015")
        arr.push("Please enter...")
        subwindow(arr, arr.size + 5)
      when /^(a|A|ａ|Ａ)(\s*|　*)(.*)/
        @q = "kill"
        setting
        config
        @my_user_id = @rest_client.user.id
        @orig_name, @screen_name = [:name, :screen_name].map{|x| @rest_client.user.send(x) }
        @main = Thread.new{stream}
      when /^(s|S|ｓ|Ｓ)(\s*|　*)(.*)/
        arr = []
        arr.push("【Setting menu】")
        arr.push("Please select one among several.")
        arr.push(" ")
        arr.push("s:Stream setting")
        arr.push("p:Plugins setting")
        arr.push("a:Account setting")
        arr.push("o:Other setting")
        arr.push(" ")
        arr.push("Please input...")
        text = subwindow(arr, arr.size + 5)
        case text
        when "s"
          stream_setting()
        when "p"
          plugins_setting()
        when "a"
          account_setting()
        when "o"
          other_setting()
        else
          text = red("Command not found")
          print "\n#{text}\n"
        end
      else
        text = red("Command not found")
        print "\n#{text}\n"
      end
      @q = false
    end
  end
  
  def error
    if $!.message == "User is over daily status update limit."
      text = red($!.message)
      print "\n#{text}\n"
      exit
    end
    if $!.class.to_s == "Twitter::Error::TooManyRequests"
      text = red($!.class.to_s)
      print "\n#{text}\n"
      exit
    end
    if $!.message == "failed to create window"
      text = red($!.message + ". terminal is too small. Please use more 65*15 size.")
      print "\n#{text}\n"
      exit
    end
    if $!.message == "nodename nor servname provided, or not known"
      text = red("No network connection")
      print "\n#{text}\n"
      exit
    end
    if $!.message == "invalid byte sequence in UTF-8"
      text = red("Faild. Please re-type.")
      print "\n#{text}\n"
      return
    end
    if $!.message == "execution expired"
      text = red("Faild:Timeout. Please retry.")
      print "\n#{text}\n"
      return
    end
    if $!.message == "Sorry, that page does not exist."
      text = red("User not found.")
      print "\n#{text}\n"
      return
    end
    text = red($!.class)
    text1 = red($!.message)
    text2 = red($!.backtrace)
    print "\n#{text}\n#{text1}\n#{text2}\n"
  end
    
  def start
    #@main = Thread.new{control}
    #stream
    @main = Thread.new{stream}
    control
    puts @q
    rescue Interrupt
      puts "終了します。"
      exit
    rescue
      error
  end
end

class Oauth
  def oauth_first
    print "Enter your consumer_key:"
    consumer_key = STDIN.gets.chomp
    print "Enter your consumer_secret:"
    consumer_secret = STDIN.gets.chomp
    @consumer = OAuth::Consumer.new(consumer_key ,consumer_secret,{
      :site=>"https://api.twitter.com"
    })
    @request_token = @consumer.get_request_token
    puts "Please access this URL"
    puts ":#{@request_token.authorize_url}"
    puts "and get the Pin code."
    print "Enter your Pin code:"
    pin  = STDIN.gets.chomp
    @access_token = @request_token.get_access_token(:oauth_verifier => pin)
    SQLite3::Database.open($TokenFile) do |db|
      db.execute <<-SQL
        CREATE TABLE IF NOT EXISTS token
          (consumer_key TEXT, consumer_secret TEXT, access_token TEXT, access_secret TEXT)
      SQL
      db.execute"INSERT INTO token VALUES (?,?,?,?)", [consumer_key, consumer_secret, @access_token.token, @access_token.secret]
    end
  rescue OAuth::Unauthorized
    text = "consumer_key or consumer_secret is wrong.please re-type it."
  rescue SQLite3::BusyException
    retry
  rescue
    $flumtter.error
  end
  
  def oauth_load
    SQLite3::Database.open($TokenFile) do |db|
      db.execute <<-SQL
        CREATE TABLE IF NOT EXISTS token
          (consumer_key TEXT, consumer_secret TEXT, access_token TEXT, access_secret TEXT)
      SQL
      db.execute <<-SQL
        CREATE TABLE IF NOT EXISTS setting
          (replies TEXT)
      SQL
      tokens = db.execute("select * from token;")
      return tokens
    end
  rescue SQLite3::BusyException
    retry
  rescue
    $flumtter.error
  end
  
  def oauth_check
    unless File::exist?($TokenFile)
      oauth_first
      SQLite3::Database.open($TokenFile) do |db|
        db.execute <<-SQL
          CREATE TABLE IF NOT EXISTS setting
            (replies TEXT)
        SQL
        db.execute <<-SQL
          CREATE TABLE IF NOT EXISTS func
            (update_name TEXT, update_description TEXT, update_location TEXT, update_url TEXT, update_icon TEXT)
        SQL
        db.execute <<-SQL
          CREATE TABLE IF NOT EXISTS other
            (terminal TEXT)
        SQL
        db.execute"INSERT INTO setting VALUES (?)", ["0"]
        db.execute"INSERT INTO func VALUES (?,?,?,?,?)", ["0", "0", "0", "0", "0"]
        db.execute"INSERT INTO other VALUES (?)", ["0"]
      end
    end
  end
end

oauth = Oauth.new
oauth.oauth_check
case ARGV[0]
when /^regist$/
  oauth.oauth_first
  $flumtter = Flumtter.new
when /^(\d+)$/
  $flumtter = Flumtter.new($1)
else
  $flumtter = Flumtter.new
end
$flumtter.start

