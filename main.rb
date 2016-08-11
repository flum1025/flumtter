# Coding: UTF-8
require_relative 'core/core'
require 'optparse'

opt = OptionParser.new
options = {}
opt.on('-d', '--debug'){|v|options[:debug] = true}
opt.on('-s', '--stream'){|v|options[:non_stream] = true}
opt.on('-r', '--read_buf'){|v|options[:non_read_buf] = true}
opt.parse!(ARGV)

Flumtter.start options
