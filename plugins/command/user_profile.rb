module Flumtter
  class Command
    class UserProfile < Base
      class Main
        class BaseElement < BufWindow::Base
          def initialize(screen,twitter,user,&block)
            super(&block)
            Window.update
            body = self.next
            loop do
              case Curses.window(screen + body + Footer)
              when /^next/, ""
                Window.update
                body = self.next
              when /^prev/
                Window.update
                body = prev
              when /^f\s(\d+)/, /^t\s(\d+)/, /^(r|R|ｒ|Ｒ)(\s*|　*)(\d+)(\s*|　*)(.*)/
                object = @elements[$1.to_i]
                unless object.nil?
                  case @input
                  when /^f\s(\d+)/
                    twitter.rest.favorite(object.id)
                  when /^t\s(\d+)/
                    twitter.rest.retweet(object.id)
                  when /^(r|R|ｒ|Ｒ)(\s*|　*)(\d+)(\s*|　*)(.*)/
                    twitter.rest.update("@#{object.user.screen_name} #{$5}", :in_reply_to_status_id => object.id)
                  end
                else
                  Curses.window Base::ObjectError
                end
              when /^exit/
                break
              else
                Curses.window Base::SyntaxError
              end
            end
          end

          Options = {count: 200}
          Footer = [
            "Command:",
            "  next(default)",
            "  prev",
            "  exit",
            "You can also use (f|t|r) command",
            "Syntax: \#{command} \#{index} \#{text}"
          ]

          def content(object, index)
            texts = [
              "#{index} ".ljust(54, '-'),
              "#{user(object.user)}",
              *parse(object.text),
              "#{created_at(object.created_at)}".ljust(54, nil, source(object.source)),
              ""
            ]
          end

          def size
            Window.y - Footer.size - 7
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
        
        class TweetElement < BaseElement
          def initialize(twitter,user)
            screen = [
              "【@#{user.screen_name}'s Tweets】"
            ]
            super(screen,twitter,user){twitter.rest.user_timeline(user.id, @cursor.nil? ? Options : Options.merge(max_id: @cursor))}
          end
        end

        class FavoriteElement < BaseElement
          def initialize(twitter,user)
            screen = [
              "【@#{user.screen_name}'s Favorites】"
            ]
            super(screen,twitter,user){twitter.rest.favorites(user.id, @cursor.nil? ? Options : Options.merge(max_id: @cursor))}
          end
        end

        class FollowElement < BufWindow::Base
          Footer = [
            "Command:",
            "  next(default)",
            "  prev",
            "  exit",
          ]

          
          def initialize(twitter,user,type)
            screen = [
              "【@#{user.screen_name}'s #{type.capitalize}】"
            ]
            super() do
              case type
              when /following/
                twitter.rest.users twitter.rest.friend_ids(user.id).to_a
              when /follower/
                twitter.rest.users twitter.rest.follower_ids(user.id).to_a
              end
            end
            
            Window.update
            body = self.next
            loop do
              case Curses.window(screen + body + Footer)
              when /^next/, ""
                Window.update
                body = self.next
              when /^prev/
                Window.update
                body = prev
              when /^exit/
                break
              else
                Curses.window SyntaxError
              end
            end
          end
          
          def size
            Window.y - Footer.size - 7
          end
          
          def content(user, index)
            texts = [
              "".ljust(56, '-'),
              "#{user(user)}",
              *parse(user.description),
              "  location:    #{user.location}",
              "  url:         #{user.url}",
              ""
            ]
          end
          
          def user(user)
            "#{user.name} (@#{user.screen_name})"
          end
          
          def parse(text)
            des = text.gsub(/(\r\n|\r|\n|\f)/,"")
            parse = [];text = ""
            des.each_char.each{|c|text.exact_size < 40 ? text << c : (parse << text;text = c)}
            (parse << text).map.with_index{|t,i|"#{["  description: "].fetch(i, ' '*15)}#{t}"}
          end
        end

        Footer = [
          "",
          "Command:",
          "  'tweet'    'follower'  'following'",
          "  'favorite' 'follow'    'unfollow'",
          "  'block'    'unblock'"
        ]

        def initialize(user, twitter)
          @user = user
          @twitter = twitter
          screen = [
            "【@#{user.screen_name} (#{user.name})'s page】",
            "".ljust(54, ' ', mutual),
            "",
            *description(user.description.dup),
            "location:    #{user.location}",
            "url:         #{user.url}",
            "",
            "tweets:    #{user.tweets_count}",
            "follow:    #{user.friends_count}",
            "follower:  #{user.followers_count}",
            "favorites: #{user.favorites_count}",
          ]
          loop do
            case Curses.window screen + Footer
            when /^tweet/
              TweetElement.new(twitter,user)
            when /^(follower|following)/
              FollowElement.new(twitter,user,$1)
            when /^favorite/
              FavoriteElement.new(twitter,user)
            when /^follow/
              twitter.rest.follow(user.screen_name)
              print "\nfollow success\n".color(:cyan)
            when /^unfollow/
              twitter.rest.unfollow(user.screen_name)
              print "\nunfollow success\n".color(:cyan)
            when /^block/
              twitter.rest.block(user.screen_name)
              print "\nblock success\n".color(:cyan)
            when /^unblock/
              twitter.rest.unblock(user.screen_name)
              print "\nunblock success\n".color(:cyan)
            when /^exit/, ""
              break
            else
              Curses.window SyntaxError
            end
          end
        end

        private

        def mutual
          friendship = @twitter.rest.friendship(@twitter.id, @user)
          following = friendship.source.following? ? ">" : "/"
          follower = friendship.source.followed_by? ? "<": "/"
          "@#{@twitter.name} #{following}=#{follower} @#{@user.screen_name}"
        end

        def description(text)
          des = text.gsub(/(\r\n|\r|\n|\f)/,"")
          parse = [];text = ""
          des.each_char.each{|c|text.exact_size < 40 ? text << c : (parse << text;text = c)}
          (parse << text).map.with_index{|t,i|"#{["description: "].fetch(i, ' '*13)}#{t}"}
        end
      end

      Header = [
        "【Select User Screen】",
        "Please input target (index or screen_name).",
        "Syntax: '\#{index|screen_name}'"
      ]

      def initialize(twitter)
        case super(nil, Header)
        when /^(\d+)(\s*|　*)(.*)/
          object = TimeLineElement::Base[$1.to_i]
          user = case object
          when ::Twitter::Tweet
            object.user
          when ::Twitter::DirectMessage
            object.sender
          else
            Curses.window ObjectError
          end
          Main.new(user,twitter)
        when /^([A-Za-z0-9_]{1,15})(\s*|　*)(.*)/
          user = twitter.rest.user($1)
          Main.new(user,twitter)
        else
          Curses.window SyntaxError
        end
      end
    end

    Help.add "p:User profile"

    new do |input, twitter|
      case input
      when /^(p|P|ｐ|ｐ)(\s*|　*)(.*)/
        UserProfile.new twitter
        true
      end
    end
  end
end