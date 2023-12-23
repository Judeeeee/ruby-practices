# frozen_string_literal: true

require 'optparse'
require 'etc'
require 'date'
require 'pathname'
require './output'
require './content'
require 'Time'

def define_option
  opt = OptionParser.new
  params = {}
  opt.on('-a') { |v| params[:a] = v }
  opt.on('-r') { |v| params[:r] = v }
  opt.on('-l') { |v| params[:l] = v }
  opt.parse!(ARGV)
  params
end

def main
  options = define_option
  output = Output.new(options)
  output.display
end

main
