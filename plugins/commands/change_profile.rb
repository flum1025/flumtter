module Flumtter
  plugin do
    class self::Profile
      include Util
      alias_method :cvr, :command_value_regexp

      def initialize(twitter)
        @twitter = twitter
        setting = Window::DynamicView.new("Change Profile", <<~EOF)
          Please select item you want to change with new profile.
          Syntax: '\#{item} \#{new profile}'
        EOF
        setting.dynamic_view do
          user = twitter.rest.user
          {
            "Current value": {
              name: user.name,
              description: user.description.split_num(40),
              location: user.location,
              url: user.website.to_s
            },
          }.indent
        end
        %w(name description url location).each do |meth|
          setting.command(cvr(meth)) do |m|
            begin
              send(meth, m)
            rescue RangeError
              Window::Popup::Error.new("Too short or Too long.").show
            end
            raise Dispel::Recall
          end
        end
        setting.show(true)
      end

      def name(m)
        m[1].range?(20)
        update_profile(name: m[1])
      end

      def description(m)
        m[1].range?(160)
        update_profile(description: m[1])
      end

      def url(m)
        m[1].range?(30)
        update_profile(url: m[1])
      end

      def location(m)
        m[1].range?(100)
        update_profile(location: m[1])
      end

      private
      def update_profile(hash)
        @twitter.rest.update_profile(hash)
      rescue Twitter::Error::Forbidden => e
        Window::Popup::Error.new(e.message).show
      end
    end

    Keyboard.add("c", "Change Profile") do |m, twitter|
      self::Profile.new(twitter)
    end
  end
end
