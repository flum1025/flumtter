module Flumtter
  plugin do
    def pane_setting(name)
      {
        "#{name}"=> [
          "flumtter -n #{name}"
        ]
      }
    end

    def mux_setting(panes)
      {
        "name"=> "flumtter",
        "root"=> "~/",
        "windows"=> [
          {
            "window1"=> {
              "layout"=> "even-horizon",
              "panes"=> panes
            }
          }
        ]
      }
    end

    def set_yml(setting)
      File.write(File.join(Dir.home, ".tmuxinator", "flumtter.yml"), YAML.dump(setting))
    end

    add_opt do |opt, options|
      opt.on('--tmux', 'enable tmux mode'){|v|options[:tmux] = v}
      opt.on('--names=V,V,...', Array, 'set account names with tmux'){|v| options[:names] = v}
    end

    run_opt(:tmux) do |v, options|
      require 'yaml'
      if options[:names] && !options[:names].empty?
        accounts = options[:names]
        setting = mux_setting(accounts.map{|a|pane_setting(a)})
        set_yml setting
      end
      `tmuxinator start flumtter`
      exit
    end

    Keyboard.add("-", "synchronize-panes on") do
      `tmux set-window-option synchronize-panes on`
      puts 'synchronize-panes on'.color(:cyan)
    end

    Keyboard.add("=", "synchronize-panes off") do
      `tmux set-window-option synchronize-panes off`
      puts 'synchronize-panes off'.color(:cyan)
    end
  end
end
