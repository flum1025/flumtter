module Flumtter
  plugin do
    Keyboard.add("n", "New Tweet") do |m, twitter|
      if m[1].empty?
        dialog = Window::Dialog.new("Tweet Screen", <<~EOF)
          Please input tweet content.
        EOF
        dialog.command(/(.+)/) do |m|
          twitter.rest.update(m[1])
        end
        dialog.show(true, false)
      else
        twitter.rest.update(m[1])
      end
    end
  end
end
