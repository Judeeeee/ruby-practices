# frozen_string_literal: true

require 'optparse'

def main
  opt = OptionParser.new
  params = {}
  opt.on('-a') { |v| params[:a] = v }
  opt.parse!(ARGV)

  case params.size
  when 0
    files = no_option_directory_item
  when 1
    files = a_option if params[:a]
  end
  output_list(files)
end

def no_option_directory_item
  Dir.glob('*')
end

def a_option
  Dir.entries('.').sort
end

def output_list(files, max_column = 3)
  result = []
  column_size = (files.size - 1) / max_column + 1
  column_size.times do |i|
    row = []
    max_column.times do
      row << files[i]
      i += column_size
    end
    result << row.compact.join(' ')
  end
  puts result
end

main
