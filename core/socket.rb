require 'socket'
@socket_file = File.join(@SourcePath, 'data/socket')

def socket
  loop do
    File.unlink @socket_file rescue nil
    sock = UNIXServer.new @socket_file
    s = sock.accept
    loop do
      command = s.recv(2048)
      callback(:command, command)
      if command.size.zero?
        break
      end
    end
  end
end

