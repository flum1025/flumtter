module Flumtter
  class Window::TweetBase < Window::Buf::Element
    def id
      @object.id
    end

    private
    def user
      "#{@object.user.name} (@#{@object.user.screen_name})"
    end

    def created_at
      @object.created_at.strftime("%Y/%m/%d %H:%M:%S")
    end

    def header
      "#{@index} ".ljust(width, ?-)
    end

    def body
      @object.text.nl
    end

    def footer
      "#{created_at}".ljust(width, nil, @object.via)
    end
  end

  module TweetBaseCommand
    extend Util
    module_function
    def add(cls)
      cls.command("f", "Favorite") do |m|
        error_handler do
          obj, _ = parse_index(m[1])
          Plugins::Favorite.favorite(obj, twitter)
        end
      end
      cls.command("t", "Retweet") do |m|
        error_handler do
          obj, _ = parse_index(m[1])
          Plugins::Retweet.retweet(obj, twitter)
        end
      end
      cls.command("r", "Reply") do |m|
        error_handler do
          obj, m2 = parse_index(m[1])
          Plugins::Reply.update(obj, m2, twitter)
        end
      end
    end
  end
end
