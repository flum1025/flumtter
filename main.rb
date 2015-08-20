# Coding: UTF-8
@SourcePath = File.expand_path('../', __FILE__)
@db = File.join(@SourcePath, 'data/flumtter.db')
require File.join(@SourcePath, 'core/core.rb')

begin
  sqlite_init
  oauth_check
  callback(:init, nil)
  account_setting
  @main = Thread.new{stream}
  @socket = Thread.new{socket}
  control
rescue Interrupt
  callback(:close, nil)
  puts text_color("終了します。")
  exit
rescue => ex
  error(ex)
end