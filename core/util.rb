module Flumtter
  module Util
    def error(e)
      print <<~EOF.color(Setting[:color][:error])
        #{e.backtrace.shift}: #{e.message} (#{e.class})
        #{e.backtrace.join("\n")}
      EOF
    end

    def error_handler(standard_error=nil,exception=nil)
      begin
        yield
      rescue => e
        error e
        standard_error.call(e) unless standard_error.nil?
      rescue Exception => e
        error e
        exception.call(e) unless exception.nil?
      end
    end
  end
end
