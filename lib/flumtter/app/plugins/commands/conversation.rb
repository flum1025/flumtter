module Flumtter
  plugin do
    Keyboard.add("g", "Conversation") do |m, twitter|
      error_handler do
        obj, _ = index_with_dialog(m[1], "Conversation Screen", <<~EOF)
          Please input target index.
        EOF
        if_tweet(obj, twitter) do |tweet|
          Window::Conversation.new(tweet, twitter).show
        end
      end
    end
  end
end
