# Coding: UTF-8

@userConfig[:db_init] ||= []
@userConfig[:db_init] << "CREATE TABLE IF NOT EXISTS stream_setting(replies TEXT)"
@userConfig[:db_init] << "CREATE TABLE IF NOT EXISTS terminal(terminal TEXT)"

@userConfig[:curses_setting] ||= {}
@userConfig[:curses_setting][:setting] = []
@userConfig[:curses_setting][:setting].push("【Setting Menu】")
@userConfig[:curses_setting][:setting].push("Please select one among several.")
@userConfig[:curses_setting][:setting].push(" ")
@userConfig[:curses_setting][:setting].push("s:Stream setting")
@userConfig[:curses_setting][:setting].push("p:Plugins setting")
@userConfig[:curses_setting][:setting].push("a:Account setting")
@userConfig[:curses_setting][:setting].push("t:Terminal setting")
@userConfig[:curses_setting][:setting].push(" ")
  
@userConfig[:curses_setting][:stream_setting] = []
@userConfig[:curses_setting][:stream_setting].push("【Stream Setting】")
@userConfig[:curses_setting][:stream_setting].push("Please input item name and value")
@userConfig[:curses_setting][:stream_setting].push("'replies': set 1 or 0")
@userConfig[:curses_setting][:stream_setting].push("syntax: 'replies 1'")
@userConfig[:curses_setting][:stream_setting].push("Input 'exit' if you want to back.")
  
@userConfig[:curses_setting][:account_manager] = []
@userConfig[:curses_setting][:account_manager].push("【Account Manager】")
@userConfig[:curses_setting][:account_manager].push("Please select the account you want to delete.")
@userConfig[:curses_setting][:account_manager].push("Input 'exit' if you want to back.")
  
@userConfig[:curses_setting][:terminal_setting] = []
@userConfig[:curses_setting][:terminal_setting].push("【Terminal Setting】")
@userConfig[:curses_setting][:terminal_setting].push("Please input command to start terminal on this OS")
@userConfig[:curses_setting][:terminal_setting].push("syntax: 'terminal \#{command}'")
@userConfig[:curses_setting][:terminal_setting].push("Command Example:")
@userConfig[:curses_setting][:terminal_setting].push("mac: \"open -a 'Terminal' '#path'\"")
@userConfig[:curses_setting][:terminal_setting].push("gnome: \"gnome-terminal -e 'ruby #path/flumtter.rb'\"")
@userConfig[:curses_setting][:terminal_setting].push("lxterminal: \"lxterminal -e 'ruby #path/flumtter.rb'\"")
@userConfig[:curses_setting][:terminal_setting].push("'#path' is converted source folder path.")
@userConfig[:curses_setting][:terminal_setting].push("Input 'exit' if you want to back.")
  
@userConfig[:curses_setting][:plugins_setting] = []
@userConfig[:curses_setting][:plugins_setting].push("【Plugins setting】")
@userConfig[:curses_setting][:plugins_setting].push("Please input item name and value")
@userConfig[:curses_setting][:plugins_setting].push("Input 'exit' if you want to back.")
@userConfig[:curses_setting][:plugins_setting].push("syntax: '\#{item} \#{value}'")
@userConfig[:curses_setting][:plugins_setting].push(" ")
  
on_event(:init) do |object|
  row = @sqlite.execute("select replies from stream_setting")
  if row.nil? || row[0].nil?
    @sqlite.execute("INSERT INTO stream_setting values('0')")
    @option = {}
  else
    if row[0][0] == "1"
      @option = {:replies => 'all'}
    else
      @option = {}
    end
  end
  row = @sqlite.execute"select terminal from terminal"
  unless row.nil? || row[0].nil?
    @command = row[0][0]
  else
    @sqlite.execute("INSERT INTO terminal values('0')")
    @command = ""
  end
end
  
def stream_setting
  loop do
    input = subwindow(@userConfig[:curses_setting][:stream_setting])
    case input
    when /^replies(\s*|　*)(\d+)/
      if $2 == "0" || $2 == "1"
        @sqlite.execute"UPDATE setting set replies = '#{$2}'"
        text = text_color("Setting success!", :cyan)
        print "\n#{text}\n"
        break
      else
        subwindow(@userConfig[:curses_setting][:wrong_number])
      end
    when /exit/
      break
    else
      subwindow(@userConfig[:curses_setting][:command_not_found])
    end
  end
end

def plugins_setting
  arr = @userConfig[:curses_setting][:plugins_setting].dup
  arr.concat(@userConfig[:plugins_setting])
  input = subwindow(arr, arr.size+10)
  callback(:plugins_setting, input)
end

def account_maneger
  loop do
    accounts = oauth_load
    arr = @userConfig[:curses_setting][:account_manager].dup
    accounts.each_with_index do |account, index|
      arr.push("#{index}:#{account[1]}")
    end
    input = subwindow(arr, accounts.size+10)
    case input
    when /^(\d+)/
      unless accounts[$1.to_i].nil?
        @sqlite.execute("DELETE FROM token WHERE ROWID = #{$1.to_i + 1}")
        text = text_color("Delete account is success!", :cyan)
        print "\n#{text}\n"
        break
      else
        subwindow(@userConfig[:curses_setting][:wrong_number])
      end
    when /exit/
      break
    else
      subwindow(@userConfig[:curses_setting][:command_not_found])
    end
  end
end

def terminal_setting
  loop do
    input = subwindow(@userConfig[:curses_setting][:terminal_setting], @userConfig[:curses_setting][:terminal_setting].size+3)
    case input
    when /^terminal\s(.+)/
      @command = $1.gsub(/#path/, @SourcePath).gsub(/'/, '"')
      @sqlite.execute"UPDATE terminal set terminal = '#{@command}'"
      text = text_color("Set command is success!", :cyan)
      print "\n#{text}\n"
      break
    when /exit/
      break
    else
      subwindow(@userConfig[:curses_setting][:command_not_found])
    end
  end
end

def setting
  input = subwindow(@userConfig[:curses_setting][:setting], @userConfig[:curses_setting][:setting].size + 5)
  case input
  when "s"
    stream_setting
  when "p"
    plugins_setting
  when "a"
    account_maneger
  when "t"
    terminal_setting
  else
    text = text_color("Command not found")
    print "\n#{text}\n"
  end
end