module Flumtter
  class Command
    Help.add "q:Open new terminal"

    TERMINAL = case HOSTOS
    when :OSX
      "open -a 'Terminal' '#{$SourcePath}'"
    when :Linux
      "gnome-terminal -e 'ruby #{File.join($SourcePath, 'flumtter.rb')}'"
    when :Windows
      "start ruby #{File.join($SourcePath, 'flumtter.rb')}"
    end

    new do |input, twitter|
      case input
      when /^(q|Q|ｑ|Ｑ)(\s*|　*)(.*)/
        terminal = $userConfig[:save_data][:setting][:terminal] || TERMINAL
        pid = Process.spawn(terminal)
        Process.detach(pid)
        print "Open new window success.".dnl.color(:cyan)
        true
      end
    end
  end

  module Setting
    class Terminal < Base
      Header = [
        "【Terminal Setting】",
        "Please input command to start terminal on this OS",
        "Syntax: 'terminal \#{command}'",
        "",
        "Current value:"
      ]

      Footer = [
        "",
        "",
        "Command Example:",
        "  mac: \"open -a 'Terminal' '#path'\"",
        "  gnome: \"gnome-terminal -e 'ruby #path/flumtter.rb'\"",
        "  lxterminal: \"lxterminal -e 'ruby #path/flumtter.rb'\"",
        "'#path' is converted source folder path.",
        "",
        "Input 'exit' if you want to back."
      ]
      
      def initialize(setting)
        loop do
          input = Curses.window Header + ["  #{setting[:terminal] || TERMINAL}"] + Footer
          case input
          when /^terminal\s(.+)/
            setting[:terminal] = $1.gsub(/#path/, $SourcePath).gsub(/'/, '"')
            print "\nSet command is success!\n".color(:cyan)
            break
          when /exit/
            break
          else
            Curses.window Curses::TextSet[:command_not_found]
          end
        end
      end
    end

    Setting.add 't:Terminal setting'

    Setting.new do |input, setting|
      case input
      when /^(t|T|ｔ|Ｔ)/
        Terminal.new setting
        true
      end
    end
  end
end