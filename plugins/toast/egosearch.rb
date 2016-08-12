module Flumtter
  class Plugins
    class Toast
      class EgoSearch < Base
        def subtitle
          "#{@object.user.name}(@#{@object.user.screen_name})"
        end
      end
    end
    
    file = File.read(File.join($SourcePath, 'plugins', 'toast', 'egosearch.regexp'))
    regexp =  file.size.zero? ? /$^/ : Regexp.compile(file)
    new(:tweet) do |object, twitter|
      Toast::EgoSearch.new(object, twitter) if object.text.match(regexp)
    end
  end
end