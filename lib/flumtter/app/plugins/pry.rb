module Flumtter
  plugin do
    add_opt do |opt, options|
      opt.on('--pry', 'console mode'){|v|options[:pry] = v}
    end

    run_opt(:pry) do
      binding.pry
      exit
    end
  end
end
