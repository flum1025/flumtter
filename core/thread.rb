=begin
module Flumtter
  class FThread < Thread
    extend Util

    EXCEPTION = proc do |e|
      exit
    end

    def self.new_with_report
      Thread.new do
        error_handler do
          yield
        end
      end
    end

    def self.new_with_restart
      Thread.new do
        loop do
          error_handler(EXCEPTION,EXCEPTION) do
            yield
          end
        end
      end
    end
  end
end
=end
