module Flumtter
  plugin do
    add_opt do |opt, options|
      opt.on('--timeline_load VALUE', 'load timeline num'){|v|options[:timeline_load] = v.to_i}
      opt.on('--[no-]timeline_load?', 'load timeline on init'){|v|options[:timeline_load?] = v}
    end

    on_event(:init) do |twitter|
      if Setting[:timeline_load?]
        twitter.rest.home_timeline(count: Setting[:timeline_load] || 20).reverse_each do |object|
          puts TimeLine::Tweet.new(object, twitter).to_s
        end
      end
    end
  end
end
