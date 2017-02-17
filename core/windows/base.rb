module Flumtter
  module Window
    class Base
      include Dispel::Util

      def initialize(title, body, 
                     hight=body.each_line.to_a.size,
                     width=body.each_line.max_by{|str|str.size}.size+2)
        @title = title
        @body = body
        @hight = hight + 8
        @width = [width,title.title.exact_size+2].max
      end
    end
  end
end
