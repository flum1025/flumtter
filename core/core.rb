module Flumtter
  $SourcePath = File.expand_path('../../', __FILE__)
  $userConfig = {}
    
  Thread.abort_on_exception = true
  
  class FlumtterException < StandardError;end
    
  module_function
  def error(e)
    if ex.message == "User is over daily status update limit."
      print e.message.background_color.color(:white).dnl
      exit
    end
    if ex.class.to_s == "Twitter::Error::TooManyRequests"
      print e.class.to_s.background_color.color(:white).dnl
      exit
    end
    if ex.message == "failed to create window"
      print "#{ex.message}. terminal is too small. Please use more 65*15 size.".background_color.color(:white).dnl
      exit
    end
    if ex.message == "nodename nor servname provided, or not known"
      print "No network connection".background_color.color(:white).dnl
      exit
    end
    if ex.message == "invalid byte sequence in UTF-8"
      print "Faild. Please re-type.".background_color.color(:white).dnl
      return
    end
    if ex.message == "execution expired"
      "Faild:Timeout. Please retry.".background_color.color(:white).dnl
      return
    end
    if ex.message == "Sorry, that page does not exist."
      "User not found.".background_color.color(:white).dnl
      return
    end
    puts [e.class, e.message, e.backtrace.join("\n")].join("\n").color
  rescue
    puts e.class, e.message, e.backtrace
  end
  
  def start(options={})
    require 'pry' if options[:debug]
    keys = AccountSelector.select(ARGV.first)
    twitter = Twitter.new keys
    twitter.read_buf unless options[:non_read_buf]
    twitter.stream unless options[:non_stream]
    Command.input_waiting(twitter)
  rescue Interrupt
    twitter.kill
    puts "終了します".color
  rescue => e
    error e
  end
  
  $userConfig[:save_data] = Marshal.load(File.read(File.join($SourcePath, 'data', 'data.bin'))) rescue {}
  at_exit {
    puts 'data saved'
    File.write(File.join($SourcePath, 'data', 'data.bin'), Marshal.dump($userConfig[:save_data]))
  }
  
  Dir.glob(File.join($SourcePath, "core/*.rb")).delete_if{|n| n.include?("core/core.rb")}.each do |core|
    require core
  end
  
  TITLE = "Flumtter"
  print TITLE.title
  at_exit {
    print "".title
  }
  
  Dir.glob(File.join($SourcePath, 'plugins', '*.rb')).each do |plugin|
    require plugin
  end
end