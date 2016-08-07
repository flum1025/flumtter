module Flumtter
  module BufWindow
    class Base
      def initialize(&block)
        @block = block
      end
      
      def size
        Window.y - 7
      end

      def prev
        @log_cursor -= 1
        @log[@log_cursor-1].nil? ? @log.first : @log[@log_cursor-1]
      end

      def next
        @elements ||= [];@log ||= [];@log_cursor ||= 0;@buf ||= [];@cursor ||= nil
        @log_cursor += 1 if @log_cursor < 0
        unless @log_cursor.zero?
          @log_cursor = @log.rindex(@log.first) if @log[@log_cursor-1].nil?
          return @log[@log_cursor-1]
        end
        arr = []
        loop do
          surp = size - arr.size
          if @buf.size.zero?
            @buf += @block.call
            @cursor = @buf.last.id
          end
          element = @buf.shift
          content = content(element, @elements.size)
          if surp > content.size
            @elements << element
            arr += content
          else
            @buf.unshift element
            break
          end
        end
        @log << arr
        arr
      end
      
      def content(object, index)
        []
      end
      
      def parse(text)
        text.each_line.map{|line|
          parse = [];text = ""
          line.each_char.each{|c|text.exact_size < 54 ? text << c : (parse << text;text = c)}
          parse << text
        }.flatten
      end
    end
  end
end