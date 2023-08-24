# frozen_string_literal: true

require 'optparse'

def main
  opt = OptionParser.new
  params = {}
  opt.on('-a') { |v| params[:a] = v }
  opt.parse!(ARGV)

  case params.size
  when 0
    files = fetch_filenames_without_dotfile
  when 1
    files = fetch_all_items if params[:a]
  end
  output_list(files)
end

def fetch_filenames_without_dotfile
  Dir.glob('*')
end

def fetch_all_items
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
