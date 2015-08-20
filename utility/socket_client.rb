# Coding: UTF-8
require 'socket'
path = File.expand_path('../', __FILE__)
socket = File.join(path, '../data/socket')

s = UNIXSocket.new socket
puts "接続しました。"

loop do
  begin
    command  = STDIN.gets.chomp
    s.write command
  rescue Errno::EPIPE
    puts "接続が切れました。"
    exit
  rescue Interrupt
    puts "切断します。"
    exit
  end
end