module Flumtter
  sarastire 'plugins/commands'

  plugin do
    Keyboard.add("v", "Version Information") do
      Window::Popup.new("Version Information", <<~EOF).show
        #{
          {
            Version: VERSION,
          }.indent
        }
      EOF
    end
  end
end
