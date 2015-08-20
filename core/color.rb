# Coding: UTF-8

def text_color(text, color=:red)
  case color
  when :black
    return "\e[30m#{text}\e[0m"
  when :red
    return "\e[31m#{text}\e[0m"
  when :green
    return "\e[32m#{text}\e[0m"
  when :yellow
    return "\e[33m#{text}\e[0m"
  when :blue
    return "\e[34m#{text}\e[0m"
  when :magenta
    return "\e[35m#{text}\e[0m"
  when :cyan
    return "\e[36m#{text}\e[0m"
  when :white
    return "\e[37m#{text}\e[0m"
  end
end

def background_color(text, color=:red)
  case color
  when :black
    return "\e[40m#{text}\e[0m"
  when :red
    return "\e[41m#{text}\e[0m"
  when :green
    return "\e[42m#{text}\e[0m"
  when :yellow
    return "\e[43m#{text}\e[0m"
  when :blue
    return "\e[44m#{text}\e[0m"
  when :magenta
    return "\e[45m#{text}\e[0m"
  when :cyan
    return "\e[46m#{text}\e[0m"
  when :white
    return "\e[47m#{text}\e[0m"
  end
end
