module Flumtter
  Dir.glob(File.join($SourcePath, 'plugins', 'command', '*.rb')).each do |command|
    require command
  end
end