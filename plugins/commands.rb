module Flumtter
  sarastire 'plugins/commands'

  Version = "5.0.0"

  plugin do
    Keyboard.add("v", "Version Information") do
      updated_at = Time.parse(`git log -1 --format='%cd'`).strftime("%Y/%m/%d")
      Window::Dialog.new("Version Information", <<~EOF).show(false,false)
        #{
          {
            Version: Version,
            "Updated at": updated_at
          }.indent
        }
      EOF
    end
  end
end
