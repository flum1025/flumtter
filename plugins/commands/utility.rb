module Flumtter
  plugin do
    Keyboard.add("e", "Exit") do
      puts "終了します".color
      exit
    end

    Keyboard.add("q", "Clear Terminal Screen") do
      print "\e[2J\e[f"
    end

    Keyboard.add("^", "Reconnection") do |m, twitter|
      twitter.kill
      twitter.start
    end
  end
end
