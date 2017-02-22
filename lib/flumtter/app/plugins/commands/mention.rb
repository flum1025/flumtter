module Flumtter
  plugin do
    Keyboard.add("m", "Mention") do |m, twitter|
      Window::Mention.new(twitter).show
    end
  end
end
