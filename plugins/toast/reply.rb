module Flumtter
  class Plugins
    class Toast
      class Reply < Base
        def title
          "#{super} #{@object.user.name}(@#{@object.user.screen_name})"
        end
      end
    end
    
    new(:tweet) do |object, twitter|
      Toast::Reply.new(object, twitter) if object.in_reply_to_user_id == twitter.id
    end
  end
end