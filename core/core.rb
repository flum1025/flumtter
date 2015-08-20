# Coding: UTF-8
@events = {}
@userConfig = {}
@temp = {}

def on_event(event, opt={}, &blk)
  @events[event] ||= []
  @events[event] << blk
end

cores = Dir.glob(File.join(@SourcePath, "core/*.rb"))
cores.delete_if{|n| n.include?("core/core.rb") }
cores.each do |file|
  require file
end

plugins = Dir.glob(File.join(@SourcePath, "plugins/*.rb"))
plugins.each do |file|
  require file
end

def callback(event, object)
  return if !@events[event]
  @events[event].each do |c|
    c.call(object)
  end
end

def get_exact_size(string)
  string.each_char.map{|c| c.bytesize == 1 ? 1 : 2}.reduce(0, &:+)
end

def indent(num=nil)
  x = @x
  x = x - num unless num == nil
  str = ""
  x.times do |i|
    str << " "
  end
  return str
end

def line(num=nil)
  x = @x
  x = x - num unless num == nil
  str = ""
  x.times do |i|
    str << "-"
  end
  return str
end

def put(char, num)
  text = ""
  num.times{|i|
    text << char
  }
  return text
end