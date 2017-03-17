module Flumtter
  module Window
    class ListTypeSelector
      Element = %i(owned_lists memberships subscriptions)

      def self.select(twitter)
        dialog = Window::Dialog.new("List Type Selector", <<~EOF)
          Please input list type number.

          #{Element.map.with_index{|e,i|"#{i}: #{e}"}.join("\n")}
        EOF
        dialog.command(/^([#{Element.size.times.to_a.join(",")}])$/) do |m|
          ListSelector.new(Element[m[1].to_i], twitter).show
        end
        dialog.show(true)
      end
    end

    class ListBase < Buf::Element
      def element
        @text ||= "#{@index}: #{@object.name}"
      end
    end

    class ListSelectorBuf < Buf::Buf
      def initialize(type, twitter, user=twitter.account.screen_name)
        @user, @type, @twitter = user, type, twitter
        super(ListBase)
      end

      def prefetch
        if @buf.empty?
          adds(@twitter.rest.send(@type, @user))
        end
      end
    end

    class ListSelector < Buf::Screen
      def initialize(type, twitter, user=twitter.account.screen_name)
        super(ListSelectorBuf.new(type, twitter, user), "#{user} #{type}")
        command(/^(\d+)$/, "list") do |m|
          error_handler do
            obj, _ = parse_index(m[1])
            List.new(obj, twitter).show
          end
        end
      end
    end

    class ListBuf < Buf::Buf
      Options = {count: 50}

      def initialize(list, twitter)
        @list, @twitter = list, twitter
        super(TweetBase)
      end

      def prefetch
        adds(
          @twitter.rest.list_timeline(@list.id,
            @buf.last.nil? ? Options : Options.merge(max_id: @buf.last.id-1)
          )
        )
      end
    end

    class List < Buf::Screen
      include Command::Tweet

      def initialize(list, twitter)
        super(ListBuf.new(list, twitter), list.name)
        add_command(twitter)
      end
    end
  end
end
