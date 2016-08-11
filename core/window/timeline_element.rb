module Flumtter
  module TimeLineElement
    class Base
      @@element = []
      def self.[](key)
        @@element[key]
      end
        
      def initialize(object)
        @@element << object
      end

      def user(user)
        "#{user.name} (@#{user.screen_name})"
      end

      def created_at(created_at)
        created_at.strftime("%Y/%m/%d %H:%M:%S")
      end

      def source(source)
        source.gsub(/<(.+)\">/,"").gsub(/<\/a>/,"")
      end
    end

    class TweetBase < Base
      def initialize(object, source="")
        super(object)
        index = @@element.rindex(object)
        @text = ""
        @text << "#{index} ".ljust(Window.x, '-', source).nl
        @text << "#{user(object.user)}".ljust(Window.x).nl
        @text << object.text.nl.nl
        @text << "#{created_at(object.created_at)}".ljust(Window.x, nil, source(object.source)).nl.nl
      end
    end

    class Tweet < TweetBase
      def initialize(object)
        super(object)
        print @text
      end
    end
    
    class MyTweet < TweetBase
      def initialize(object)
        super(object)
        print @text.color(:cyan)
      end
    end

    class Retweet < TweetBase
      def initialize(object)
        super(object.retweeted_status, "<< @#{object.user.screen_name} :(#{object.retweeted_status.retweet_count})")
        print @text.color(:blue)
      end
    end

    class Fav < TweetBase
      def initialize(object)
        super(object.target_object, "<< @#{object.source.screen_name} :(#{object.target_object.favorite_count})")
        print @text.color(:yellow)
      end
    end

    class DirectMessage < Base
      def initialize(object)
        super(object)
        index = @@element.rindex(object)
        text = ""
        text << "#{index} ".ljust(Window.x, '-').nl
        text << "#{user(object.sender)}".ljust(Window.x).nl
        text << object.text.nl.nl
        text << "#{created_at(object.created_at)}".ljust(Window.x, nil).nl.nl
        print text.color(:magenta)
      end
    end
  end
end