module Flumtter
  class Terminal
    class << self
      def x
        `tput cols`.to_i
      end

      def y
        `tput lines`.to_i
      end
    end
  end
end
