module Flumtter
  plugin do
    def update(obj,text,twitter)
      twitter.rest.update("@#{obj.user.screen_name} #{text}", :in_reply_to_status_id => obj.id)
    end

    Keyboard.add("r", "Reply") do |m, twitter|
      error_handler do
        obj, m2 = index_with_dialog(m[1], "Reply Screen", <<~EOF)
          Please input target index and tweet content.
          Syntax: '\#{index} \#{content}'
        EOF
        case obj
        when Twitter::Tweet, Twitter::Streaming::Event
          if_tweet(obj, twitter) do |tweet|
            update(tweet, m2, twitter)
          end
        when Twitter::DirectMessage
          twitter.rest.create_direct_message(obj.sender.id, m2)
        else
          raise UnSupportError
        end
      end
    end
  end
end
