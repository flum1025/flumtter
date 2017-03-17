module Flumtter
  plugin do
    Keyboard.add("o", "List") do |m, twitter|
      error_handler do
        Window::ListTypeSelector.select(twitter)
      end
    end
  end
end
