# Coding: UTF-8
require 'curses'

@x = `tput cols`.to_i
@y = `tput lines`.to_i

@userConfig[:curses_setting] ||= {}
@userConfig[:curses_setting][:wrong_number] = []
@userConfig[:curses_setting][:wrong_number].push("wrong number!!!!!!!")
@userConfig[:curses_setting][:wrong_number].push("Please re-setting.")
@userConfig[:curses_setting][:wrong_number].push("Please enter...")
  
@userConfig[:curses_setting][:command_not_found] = []
@userConfig[:curses_setting][:command_not_found].push("Command not found")
@userConfig[:curses_setting][:command_not_found].push("Please re-setting.")
@userConfig[:curses_setting][:command_not_found].push("Please enter...")

def window_clear
  s = Curses.stdscr.subwin(@y-2, @x-2, 1, 1)
  s.refresh
  s.clear
end

def subwindow(texts, high=10, width=60)
  window_clear
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

def subwindow_one(texts, high=10, width=60)
  window_clear
  x = 1
  y = 1
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
  input = s.getch
  input.encode!('UTF-16', 'UTF-8', :invalid => :replace, :replace => '')
  input.encode!('UTF-8', 'UTF-16')
  s.clear
  s.close
  Curses.close_screen
  return input
end