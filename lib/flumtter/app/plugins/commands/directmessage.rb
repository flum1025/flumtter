module Flumtter
  plugin do
    def directmessage(user, text, twitter)
      case user
      when Twitter::User
        twitter.rest.create_direct_message(user.id, text)
      else
        twitter.rest.create_direct_message(user, text)
      end
    end

    Keyboard.add("d", "Direct Message") do |m, twitter|
      error_handler do
        obj, m2 = index_with_dialog(m[1], "DirectMessage Screen", <<~EOF, true)
          Please input target (index or screen_name) and DM content.
          Syntax: '\#{index} \#{content}'
        EOF
        raise NoContentError if m2.empty?

        case obj
        when Twitter::Tweet, Twitter::Streaming::Event
          if_tweet(obj, twitter) do |tweet|
            directmessage(tweet.user, m2, twitter)
          end
        when Twitter::DirectMessage
          directmessage(obj.sender, m2, twitter)
        when String
          directmessage(obj, m2, twitter)
        else
          raise UnSupportError
        end
      end
    end
  end
end
