module Flumtter
  module TimeLineElement
    class Deleted < Base
      def initialize(object)
        obj = @@element.find{|elem|elem.kind_of?(::Twitter::Tweet) && elem.id == object.id}
        return if obj.nil?
        text = ""
        text << "DELETED ".ljust(Window.x, '-').nl
        text << "#{user(obj.user)}".ljust(Window.x).nl
        text << obj.text.nl.nl
        text << "#{created_at(obj.created_at)}".ljust(Window.x, nil, source(obj.source)).nl.nl
        print text.background_color(:blue)
      end
    end

    Plugins.new(:deletedtweet) do |object, twitter|
      Deleted.new(object)
    end
  end
end