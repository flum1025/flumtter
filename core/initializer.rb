require 'optparse'

module Initializer
  @args, @events = [], {}

  module_function
  def add_opt(&blk)
    @args << blk
  end

  def run(sym, &blk)
    @events[sym] = blk
  end

  def optparse
    opt = OptionParser.new
    opt.on('--args VALUE'){|v|options[:args] = v}
    options = {}
    @args.each{|args|args.call(opt, options)}
    opt.parse!(ARGV)
    options.each{|k,v|@events[k].call(v,options) unless @events[k].nil?}
    options
  end
end
