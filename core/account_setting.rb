# Coding: UTF-8
@userConfig[:curses_setting] ||= {}
@userConfig[:curses_setting][:account_setting] = []
@userConfig[:curses_setting][:account_setting].push("【Account Setting】")
@userConfig[:curses_setting][:account_setting].push("Please input your account number.")
@userConfig[:curses_setting][:account_setting].push("Input 'regist' if you want to regist new account.")
  
def account_setting(num=nil)
  loop do
    if num.nil?
      accounts = oauth_load
      arr = @userConfig[:curses_setting][:account_setting].dup
      accounts.each_with_index do |account, index|
        arr.push("#{index}:#{account[1]}")
      end
      input = subwindow(arr, accounts.size+10)
    else
      input = num
    end
    case input
    when /^(\d+)/
      unless accounts[$1.to_i].nil?
        config(accounts[$1.to_i])
        break
      else
        subwindow(@userConfig[:curses_setting][:wrong_number])
      end
    when /regist/
      oauth_first
      break
    else
      subwindow(@userConfig[:curses_setting][:command_not_found])
    end
  end
end