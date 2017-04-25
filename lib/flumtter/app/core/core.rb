require 'pry'
require 'json'
require 'logger'

module Flumtter
  StartTime = Time.now
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

  Logger = Logger.new(UserPath.join('flumtter.log'))
  Logger.level = ARGV.include?('--debug') ? ::Logger::DEBUG : ::Logger::INFO
  Logger.datetime_format = "%Y-%m-%d %H:%M:%S.%L "

  Logger.debug("Start: #{ARGV.join(" ")}")

  data_path = UserPath.join("data", "data.bin")
  Config = Marshal.load(File.read(data_path)) rescue {}
  at_exit {
    File.write(data_path, Marshal.dump(Config))
  }

  Thread.abort_on_exception = true

  module_function
  def logger
    Logger
  end

  def load_plugin(source, path, file=nil)
    path = file.nil? ? source.join(path, '*.rb') : source.join(path, file)
    Dir.glob(path).each do |plugin|
      logger.debug("Load: #{plugin}")
      require plugin
    end
  end

  def sarastire(*args)
    load_plugin(SourcePath, *args)
  end

  def sarastire_user(*args)
    load_plugin(UserPath, *args)
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

  logger.debug("Plugin load complete.")

  TITLE.terminal_title

  logger.debug("Initialization time(#{Time.now-StartTime}s)")

  def start
    options = Initializer.optparse
    Setting.merge!(options)
    Client.new AccountSelector.select(options)
  rescue Interrupt
  rescue Exception => ex
    logger.fatal(<<~EOS)
      #{ex.backtrace.shift}: #{ex.message} (#{ex.class})
      #{ex.backtrace.join("\n")}
    EOS
    raise ex
  end
end
