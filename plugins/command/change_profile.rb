module Flumtter
  class Command
    class ChangeProfile < Base
      Screen = [
        "【Change Profile】",
        "Please select item you want to change with new profile.",
        "Item:",
        "  name",
        "  description",
        "  url",
        "  location",
        "Syntax: '\#{item} \#{new profile}'",
        "",
        "Current value:"
      ]
      
      def initialize(twitter)
        user = twitter.rest.user
        current = [
          "  name:        #{user.name}",
          *description(user.description.dup),
          "  location:    #{user.location}",
          "  url:         #{user.url}"
        ]
        super(nil, Screen + current)
        case @input
        when /^name\s(.*)/
          unless 1 > $1.length || 20 < $1.length
            twitter.rest.update_profile(name: $1)
            print "Change name Success.".dnl.color(:cyan)
          else
            print "New name is too short or too long.".dnl.color
          end
        when /^description\s(.*)/
          unless 1 > $1.length || 160 < $1.length
            twitter.rest.update_profile(description: $1)
            print "Change description Success.".dnl.color(:cyan)
          else
            print "New description is too short or too long.".dnl.color
          end
        when /^url\s(.*)/
          if 1 > $1.length || 100 < $1.length
            print "New url is too short or too long.".dnl.color
          elsif $1.start_with?("http://") == false
            print "New url is wrong.".dnl.color
          else
            twitter.rest.update_profile(url: $1)
            print "Change url Success.".dnl.color(:cyan)
          end
        when /^location\s(.*)/
          unless 1 > $1.length || 30 < $1.length
            twitter.rest.update_profile(location: $1)
            print "Change location Success.".dnl.color(:cyan)
          else
            print "New location is too short or too long.".dnl.color
          end
        else
          Curses.window SyntaxError
        end
      end
      
      def description(text)
        des = text.gsub(/(\r\n|\r|\n|\f)/,"")
        parse = [];text = ""
        des.each_char.each{|c|text.exact_size < 40 ? text << c : (parse << text;text = c)}
        (parse << text).map.with_index{|t,i|"#{["  description: "].fetch(i, ' '*15)}#{t}"}
      end
    end

    Help.add "u:Change profile"

    new do |input, twitter|
      case input
      when /^(u|U|ｕ|Ｕ)(\s*|　*)(.*)/
        ChangeProfile.new twitter
        true
      end
    end
  end
end