module Flumtter
  module Window
    class Base
      include Dispel::Util

      def initialize(title, body, 
                     hight=body.size_of_lines,
                     width=body.max_char_of_lines+2)
        @title = title
        @body = body
        @hight = hight + 8
        @width = [width,title.title.exact_size+2].max
      end
    end

    def self.close
      raise Dispel::CloseWindow
    end
  end
end
