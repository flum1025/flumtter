module Flumtter
  plugin do
    class self::Profile < Window::DynamicView
      include Command::User

      def initialize(object, twitter)
        @twitter = twitter
        parse(object)
        super("#{@user.screen_name}'s profile", "")
        @width = 60
        dynamic_view do
          user = twitter.rest.user(@user)
          <<~EOF
            #{mutual.rjust(@width - 3)}
            #{profile(user)}

            #{statistics(user)}
          EOF
        end
        add_command(@user, twitter)
        show(true)
      end

      private
      def mutual
        friendship = @twitter.rest.friendship(@twitter.account.id, @user)
        following = friendship.source.following? ? ">" : "/"
        follower = friendship.source.followed_by? ? "<": "/"
        "@#{@twitter.account.screen_name} #{following}=#{follower} @#{@user.screen_name}"
      end

      def profile(user)
        {
          name: user.name,
          description: user.description.split_num(44),
          location: user.location,
          url: user.website.to_s
        }.indent
      end

      def statistics(user)
        {
          tweets: user.tweets_count,
          follow: user.friends_count,
          follower: user.followers_count,
          favorite: user.favorites_count
        }.indent
      end

      def parse(obj)
        @user = case obj
        when Twitter::Tweet
          obj.user
        when Twitter::DirectMessage
          ob.sender
        when Twitter::Streaming::Event
          ob.source
        when Twitter::Streaming::DeletedTweet
          obj.user
        when String
          @twitter.rest.user(obj)
        else
          raise UnSupportError
        end
      end
    end

    Keyboard.add("p", "User Profile") do |m, twitter|
      error_handler do
        obj, _ = index_with_dialog(m[1], "Select User Screen", <<~EOF, true)
          Please input target (index or screen_name) and DM content.
        EOF
        self::Profile.new(obj, twitter)
      end
    end
  end
end
