require 'pry'
require 'json'

module Flumtter
  SourcePath = File.expand_path('../../', __FILE__)
  UserPath = File.expand_path('~/.flumtter')
  [SourcePath, UserPath].each do |path|
    def path.join(*args)
      File.join(self, *args)
    end
  end
  unless FileTest.exist?(UserPath)
    FileUtils.cp_r(SourcePath.join(".flumtter"), UserPath)
  end

  old_data_path = UserPath.join("data", "data.bin")
  data_path = UserPath.join("data", "keys.json")

  Config = if File.exist?(data_path)
    JSON.parse(File.read(data_path), {:symbolize_names => true})
  elsif File.exist?(old_data_path)
    puts "Migrating config data.bin to keys.json"
    config = Marshal.load(File.read(old_data_path)) rescue {}
    File.write(data_path, config.to_json)
    File.unlink(old_data_path)
    puts "Migration Success"
    config
  end

  at_exit {
    File.write(data_path, Config.to_json)
  }

  Thread.abort_on_exception = true

  module_function
  def sarastire(path, file=nil)
    path = file.nil? ? SourcePath.join(path, '*.rb') : SourcePath.join(path, file)
    Dir.glob(path).each{|plugin|require plugin}
  end

  def sarastire_user(path, file=nil)
    path = file.nil? ? UserPath.join(path, '*.rb') : UserPath.join(path, file)
    Dir.glob(path).each{|plugin|require plugin}
  end

  @events = Hash.new{|h,k|h[k] = []}
  def on_event(event,&blk)
    @events[event] << blk
  end

  def callback(event,object=nil)
    @events[event].each{|blk|blk.call(object)}
  end

  TITLE = "Flumtter"

  sarastire 'core', 'util.rb'
  sarastire_user 'setting'
  sarastire 'core'
  sarastire 'plugins'
  sarastire_user 'plugins'

  TITLE.terminal_title

  def start
    options = Initializer.optparse
    Setting.merge!(options)
    Client.new AccountSelector.select(options)
  rescue Interrupt
  end
end
