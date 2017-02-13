module Flumtter
  plugin do
    Keyboard.add(/test/, 'test') do
      p Terminal.x
    end
  end
end
