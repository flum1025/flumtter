module Flumtter
  class Command
    class Conversation < Base
      class Element < BufWindow::Base
        Header = [
          "【Conversations】"
        ]

        Footer = [
          "Command:",
          "  next(default)",
          "  prev",
          "  exit",
          "You can also use (f|t|r) command",
          "Syntax: \#{command} \#{index} \#{text}"
        ]

        def read_buf(object=@object)
          @buf << object
          read_buf(@block.call(object.in_reply_to_status_id)) if object.in_reply_to_status_id?
        end

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

        def next
          @log_cursor += 1 if @log_cursor < 0
          unless @log_cursor.zero?
            @log_cursor = @log.rindex(@log.first) if @log[@log_cursor-1].nil?
            return @log[@log_cursor-1]
          end
          arr = []
          loop do
            surp = size - arr.size
            break if @buf.size.zero?
            element = @buf.shift
            content = content(element, @elements.size)
            if surp > content.size
              @elements << element
              arr += content
            else
              @buf.unshift element
              break
            end
          end
          @log << arr
          arr
        end

        def initialize(twitter,object)
          @object = object
          super(){|id|twitter.rest.status(id)}
          read_buf
          Window.update
          body = self.next
          loop do
            case Curses.window(Header + body + Footer)
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
      end

      Screen = [
        "【Conversations Screen】",
        "Please input target index.",
        "Syntax: '\#{index}'"
      ]

      NoInReplyToError = [
        "【ERROR】",
        "Not found conversations."
      ]

      def initialize(twitter, text)
        super(text, Screen)
        case @input
        when /^(\d+)(\s*|　*)(.*)/
          object = TimeLineElement::Base[$1.to_i]
          if object.in_reply_to_status_id?
            Element.new(twitter,object)
          else
            Curses.window NoInReplyToError
          end
        else
          Curses.window SyntaxError
        end
      end
    end

    Help.add "g:Conversation"

    new do |input, twitter|
      case input
      when /^(g|G|ｇ|Ｇ)(\s*|　*)(.*)/
        Conversation.new twitter, $3
        true
      end
    end
  end
end