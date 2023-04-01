#!/usr/bin/env ruby

require 'optparse'

options = {}

parser = OptionParser.new do |parser|
  parser.on("-r", "--random RANDOM_JOKES_COUNT", "Render n random jokes")
end

parser.parse!(into: options)

puts options.inspect