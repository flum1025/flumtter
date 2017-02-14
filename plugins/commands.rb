module Flumtter
  sarastire 'plugins/commands'

  Version = "5.0.0"

  plugin do
    Keyboard.add("v", "Version Information") do
      Dialog.new("Version Information", <<~EOF).show(false,false)

        Version:     #{Version}
        Updated at:  #{
          date = `git log -1 --format='%cd'`
          Time.parse(date).strftime("%Y/%m/%d")
        }
      EOF
    end
  end
end
