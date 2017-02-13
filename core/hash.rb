class Hash
  def requires(*args)
    args.each do |arg|
      raise ArgumentError, "Parameter is missing a value(#{arg})" if self[arg].nil?
    end
  end
end
