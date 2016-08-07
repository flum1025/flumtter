class String
  def color(color=:red)
    case color
    when :black
      "\e[30m#{self}\e[0m"
    when :red
      "\e[31m#{self}\e[0m"
    when :green
      "\e[32m#{self}\e[0m"
    when :yellow
      "\e[33m#{self}\e[0m"
    when :blue
      "\e[34m#{self}\e[0m"
    when :magenta
      "\e[35m#{self}\e[0m"
    when :cyan
      "\e[36m#{self}\e[0m"
    when :white
      "\e[37m#{self}\e[0m"
    end
  end

  def background_color(color=:red)
    case color
    when :black
      "\e[40m#{self}\e[0m"
    when :red
      "\e[41m#{self}\e[0m"
    when :green
      "\e[42m#{self}\e[0m"
    when :yellow
      "\e[43m#{self}\e[0m"
    when :blue
      "\e[44m#{self}\e[0m"
    when :magenta
      "\e[45m#{self}\e[0m"
    when :cyan
      "\e[46m#{self}\e[0m"
    when :white
      "\e[47m#{self}\e[0m"
    end
  end
  
  def title
    "\033];#{self}\007"
  end
  
  def has_mb?
    self.bytes do |b|
      return true if  (b & 0b10000000) != 0
    end
    false
  end
  
  def nl
    self + "\n"
  end
  
  def dnl
    "\n#{self}\n"
  end
  
  def exact_size
    self.each_char.map{|c| c.bytesize == 1 ? 1 : 2}.reduce(0, &:+)
  end
  
  alias_method :_ljust, :ljust
  def ljust(length, padstr=nil, rstr="")
    length -= (exact_size - 1) if has_mb?
    length -= rstr.exact_size
    text = padstr.nil? ? _ljust(length) : _ljust(length, padstr)
    text << rstr
  end
end
