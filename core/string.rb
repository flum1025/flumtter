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
end
