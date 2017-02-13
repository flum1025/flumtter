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

  module_function
  def sarastire(path, file=nil)
    path = file.nil? ? SourcePath.join(path, '*.rb') : SourcePath.join(path, file)
    Dir.glob(path).each{|plugin|require plugin}
  end

  sarastire 'core'
  sarastire 'plugins'

  "Flumtter".terminal_title

  def start
    options = Initializer.optparse
    AccountSelector.select options
  rescue Interrupt
  end
end
