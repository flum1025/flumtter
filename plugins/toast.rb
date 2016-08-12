module Flumtter
  class Plugins
    class Toast
      class Base
        ToastCommand = case HOSTOS
        when :OSX
          lambda{|title, subtitle, text|`osascript -e 'display notification "#{text}" with title "#{title}" subtitle "#{subtitle}"'`}
        when :Linux
        when :Windows
        end
        
        def initialize(object, twitter)
          @object = object
          @twitter = twitter
          ToastCommand.call(title, subtitle, object.text)
        end
        
        def title
          "#{TITLE}(#{@twitter.name})"
        end
        
        def subtitle
          ""
        end
      end
    end
  end
  
  Dir.glob(File.join($SourcePath, 'plugins', 'toast', '*.rb')).each do |command|
    require command
  end
end