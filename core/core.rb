require 'pry'

module Flumtter
  SourcePath = File.expand_path('../../', __FILE__)
  def SourcePath.join(*args)
    File.join(SourcePath, *args)
  end

  data_path = SourcePath.join("data", "data.bin")
  Config = Marshal.load(File.read(data_path)) rescue {}
  at_exit {
    puts 'data saved'
    File.write(data_path, Marshal.dump(Config))
  }

  Thread.abort_on_exception = true

  module_function
  def sarastire(path, file=nil)
    path = file.nil? ? SourcePath.join(path, '*.rb') : SourcePath.join(path, file)
    Dir.glob(path).each{|plugin|require plugin}
  end

  @events = Hash.new{|h,k|h[k] = []}
  def on_event(event,&blk)
    @events[event] << blk
  end

  def callback(event,object=nil)
    @events[event].each{|blk|blk.call(object)}
  end

  sarastire 'core', 'util.rb'
  sarastire 'setting'
  sarastire 'core'
  sarastire 'plugins'

  TITLE = "Flumtter"
  TITLE.terminal_title

  def start
    options = Initializer.optparse
    Setting.merge!(options)
    AccountSelector.select options
  rescue Interrupt
  end
end
