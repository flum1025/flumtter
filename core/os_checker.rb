module Flumtter
  HOSTOS = 
  if RUBY_PLATFORM.match(/darwin/)
    :OSX
  elsif RUBY_PLATFORM.downcase =~ /mswin(?!ce)|mingw|cygwin|bccwin/
    :Windows
  elsif RUBY_PLATFORM.match(/linux/)
    :Linux
  else
    :Unknown
  end
end