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
    options = {}
    opt.on('-n VALUE', '--name VALUE', "account name"){|v|options[:name] = v}
    opt.on('-i VALUE', '--index VALUE', "account index"){|v|options[:id] = v.to_i}
    opt.on('--args VALUE'){|v|options[:args] = v}
    @args.each{|args|args.call(opt, options)}
    opt.parse!(ARGV)
    options.each{|k,v|@events[k].call(v,options) unless @events[k].nil?}
    options
  end
end
