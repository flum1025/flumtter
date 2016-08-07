module Flumtter
  class Plugins
    def self.new(event, &blk)
      Twitter.on_event(event, &blk)
    end
  end
end
