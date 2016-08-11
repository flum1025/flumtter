module Flumtter
  class Plugins
    class Toast
      class Base
        ToastCommand = case HOSTOS
        when :OSX
          lambda{|title, text|`osascript -e 'display notification "#{title}" with title "#{text}"'`}
        when :Linux
        when :Windows
        end
        
        def initialize(object, twitter)
          @object = object
          @twitter = twitter
          ToastCommand.call(object.text, title)
        end
        
        def title
          "#{TITLE}(#{@twitter.name})"
        end
      end
    end
  end
  
  Dir.glob(File.join($SourcePath, 'plugins', 'toast', '*.rb')).each do |command|
    require command
  end
end