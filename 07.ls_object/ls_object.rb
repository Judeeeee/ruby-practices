# frozen_string_literal: true

require 'optparse'
require './terminal_display'
require './content'

def read_options
  opt = OptionParser.new
  options = {}
  opt.on('-a') { |v| options[:a] = v }
  opt.on('-r') { |v| options[:r] = v }
  opt.on('-l') { |v| options[:l] = v }
  opt.parse!(ARGV)
  options
end

def main
  options = read_options
  terminal_display = TerminalDisplay.new(options)
  terminal_display.output
end

main
