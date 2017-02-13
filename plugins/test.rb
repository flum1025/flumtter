module Flumtter
  plugin do
    add_opt do |opt, options|
      opt.on('-l VALUE'){|v|options[:log] = v}
    end

    run_opt(:log) do |v|
      p v
    end
  end
end
