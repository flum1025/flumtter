require 'yaml'

module Flumtter
  class Mute
    @@condition = {text: /$^/, user: /$^/, source: /$^/}

    def self.set key, value
      @@condition[key] = Regexp.union(value)
    end

    def self.parse(object)
      case object
      when ::Twitter::Tweet
        return object.text, object.user.screen_name, object.source
      when ::Twitter::Streaming::Event
        parse object.target_object
      when ::Twitter::DirectMessage
        return object.text, object.sender.screen_name, nil
      end
    end

    def self.mute?(object)
      text, user, source = parse(object)
      unless text.nil?
        text =~ @@condition[:text]
      end
      unless user.nil?
        user =~ @@condition[:user]
      end
      unless source.nil?
        source =~ @@condition[:source]
      end
      false
    end
  end
  
  mute = YAML.load_file(File.join($SourcePath, 'plugins', 'mute.yml'))
  mute.each{|k,v|Mute.set k, v}
end