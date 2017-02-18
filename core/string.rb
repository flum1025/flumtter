class String
  def to_camel
    self.split(/_/).map(&:capitalize).join
  end

  def terminal_title
    print "\033];#{self}\007"
    at_exit{print "\033];\007"}
  end

  def title
    "【#{self}】"
  end

  def color(color=:red)
    case color
    when :white       then "\e[1;37m#{self}\e[0m"
    when :light_gray  then "\e[37m#{self}\e[0m"
    when :gray        then "\e[1;30m#{self}\e[0m"
    when :back        then "\e[30m#{self}\e[0m"
    when :red         then "\e[31m#{self}\e[0m"
    when :light_red   then "\e[1;31m#{self}\e[0m"
    when :green       then "\e[32m#{self}\e[0m"
    when :light_green then "\e[1;32m#{self}\e[0m"
    when :brown       then "\e[33m#{self}\e[0m"
    when :yellow      then "\e[1;33m#{self}\e[0m"
    when :blue        then "\e[34m#{self}\e[0m"
    when :light_blue  then "\e[1;34m#{self}\e[0m"
    when :purple      then "\e[35m#{self}\e[0m"
    when :pink        then "\e[1;35m#{self}\e[0m"
    when :cyan        then "\e[36m#{self}\e[0m"
    when :light_cyan  then "\e[1;36m#{self}\e[0m"
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

  def exact_size
    self.each_char.map{|c| c.bytesize == 1 ? 1 : 2}.reduce(0, &:+)
  end

  def nl(i=1)
    self + "\n"*i
  end

  def dnl
    "\n#{self}\n"
  end

  def has_mb?
    self.bytes do |b|
      return true if  (b & 0b10000000) != 0
    end
    false
  end

  alias_method :_ljust, :ljust
  def ljust(length, padstr=nil, rstr="")
    length -= (exact_size - 1) if has_mb?
    length -= rstr.exact_size
    text = padstr.nil? ? _ljust(length) : _ljust(length, padstr)
    text << rstr
  end

  def to_em
    self.tr('0-9a-zA-Z', '０-９ａ-ｚＡ-Ｚ')
  end

  def to_en
    self.tr('０-９ａ-ｚＡ-Ｚ', '0-9a-zA-Z')
  end

  def to_reg
    reg = Regexp.union(self, self.to_em)
    /#{Regexp.new(reg.source, Regexp::IGNORECASE)}[ |　]*(.*)/
  end

  def shift(n=2)
    self.each_line.map do |line|
      " "*n + line.chomp
    end.join("\n")
  end

  def nshift(n=2)
    self.each_line.map.with_index do |line, i|
      if i.zero?
        line.chomp
      else
        " "*n + line.chomp
      end
    end.join("\n")
  end

  def split_num(n)
    self.scan(/.{1,#{n}}/).join("\n")
  end

  def range?(max)
    unless 1 <= self.size && self.size <= max
      raise RangeError
    end
  end

  def size_of_lines
    self.each_line.to_a.size
  end

  def max_char_of_lines
    self.each_line.max_by{|str|str.size}.size
  end
end

if $0 == __FILE__
  %i(white light_gray gray black red light_red green light_green brown yellow blue light_blue purple pink cyan light_cyan).each do |c|
    puts "#{c}".color(c)
  end
end
