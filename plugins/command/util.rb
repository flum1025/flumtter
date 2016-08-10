module Flumtter
  class Command
    Help.add "e:Exit"
    Help.add "c:Clear the terminal screen"
    Help.add "z:Forced termination and clear the terminal screen"
    Help.add "^:Reconnection"
    Help.add "¥:Refresh"

    new do |input, twitter|
      case input
      when /^(e|E|ｅ|Ｅ)(\s*|　*)(.*)/
        puts "終了します。".color
        exit
      when /^(c|C|ｃ|Ｃ)(\s*|　*)(.*)/
        print "\e[2J\e[f"
        true
      when /^(z|Z|ｚ|Ｚ)(\s*|　*)(.*)/
        print "\e[2J\e[f"
        exit
      when /^(\^|＾|~)(\s*|　*)(.*)/
        twitter.kill
        twitter.stream
        true
      when /^(\¥|\|)(\s*|　*)(.*)/
        twitter.kill
        twitter.read_buf
        twitter.stream
        true
      end
    end
  end
end