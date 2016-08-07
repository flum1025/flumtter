module Flumtter
  Dir.glob(File.join($SourcePath, 'core', 'window', '*.rb')).each do |window|
    require window
  end
  
  class Window
    @@x = 80
    @@y = 24
    def self.x; @@x end
    
    def self.y; @@y end
    
    def self.update
      cols = `tput cols`.to_i     #cols = ::Curses.cols
      lines = `tput lines`.to_i   #lines = ::Curses.lines
      @@x = cols unless cols.zero?
      @@y = lines unless lines.zero?
    end
  end
end