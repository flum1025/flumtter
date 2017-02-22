class Hash
  def requires(*args)
    args.each do |arg|
      raise ArgumentError, "Parameter is missing a value(#{arg})" if self[arg].nil?
    end
  end

  def nest_level(level=0)
    self.map do |k,v|
      if v.is_a?(Hash)
        v.nest_level(level+1)
      else
        level+1
      end
    end.max
  end

  def indent(t=0, n=2)
    self.map do |k,v|
      if self.nest_level == 1 || !v.is_a?(Hash)
        between = ": "
        char_len = self.keys.max_by{|key|key.size}.size + (n * t)
        k.to_s.shift(t*n).ljust(char_len) + ": " + v.to_s.nshift(char_len + between.size)
      else
        [k.to_s.shift(t*n), *v.is_a?(Hash) ? v.indent(t+1, n) : [v.to_s.shift(n*2)]].join("\n")
      end
    end.join("\n")
  end
end
