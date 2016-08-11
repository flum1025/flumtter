module Flumtter
  class Plugins
    class Toast
      class DirectMessage < Base
        def title
          "#{super} #{@object.sender.name}(@#{@object.sender.screen_name})"
        end
      end
    end
    
    new(:directmessage) do |object, twitter|
      Toast::DirectMessage.new(object, twitter) if object.sender.id != twitter.id
    end
  end
end