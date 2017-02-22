require_relative 'base'

module Flumtter
  module TimeLine
    class Event < Base
      def header
        "#{index} ".ljust(Terminal.x, ?-, "<< @#{source_user} :(#{info})")
      end
    end
  end
end
