# frozen_string_literal: true

require 'optparse'
require './output'
require './content'

def read_options
  opt = OptionParser.new
  params = {}
  opt.on('-a') { |v| params[:a] = v }
  opt.on('-r') { |v| params[:r] = v }
  opt.on('-l') { |v| params[:l] = v }
  opt.parse!(ARGV)
  params
end

def main
  options = read_options
  output = Output.new(options)
  output.display
end

main
