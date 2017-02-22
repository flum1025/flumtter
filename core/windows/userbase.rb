module Flumtter
  module Window
    class UserBase < Buf::Element
      def id
        @object.id
      end

      def element
        @text ||= <<~EOF
          #{header}
          #{
            {
              "#{@object.name} (@#{@object.screen_name})": {
                description: @object.description.split_num(Terminal.x - 20),
                location: @object.location,
                url: @object.website.to_s
              }
            }.indent
          }
        EOF
      end
    end

    class UserBuf < Buf::Buf
      Options = {count: 50}

      def initialize(user, twitter)
        @twitter = twitter
        @user = user
        super(UserBase)
      end
    end

    class User < Buf::Screen
      include Command::UserList

      def initialize(buf, title, twitter)
        super(buf, title)
        add_command(twitter)
      end
    end
  end
end
