module Flumtter
  class Command
    class Mention < Base
      class Element < BufWindow::Base
        Options = {count: 200}
        
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
      
      Footer = [
        "Command:",
        "  next(default)",
        "  prev",
        "  exit",
        "You can also use (f|t|r) command",
        "Syntax: \#{command} \#{index} \#{text}"
      ]

      def initialize(twitter)
        element = Element.new{twitter.rest.mentions(@cursor.nil? ? Element::Options : Element::Options.merge(max_id: @cursor))}
        screen = [
          "【@#{twitter.name}'s Mentions】"
        ]
        Window.update
        body = element.next
        loop do
          case super(nil, screen + body + Footer)
          when /^next/, ""
            Window.update
            body = element.next
          when /^prev/
            Window.update
            body = element.prev 
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
              Curses.window ObjectError
            end
          when /^exit/
            break
          else
            Curses.window SyntaxError
          end
        end
      end
    end

    Help.add "m:Mention"

    new do |input, twitter|
      case input
      when /^(m|M|ｍ|Ｍ)(\s*|　*)(.*)/
        Mention.new twitter
        true
      end
    end
  end
end