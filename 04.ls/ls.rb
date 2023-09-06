# frozen_string_literal: true

require 'optparse'

def main
  opt = OptionParser.new
  params = {}
  opt.on('-r') { |v| params[:r] = v }
  opt.parse!(ARGV)

  files = fetch_filenames_without_dotfile
  files = reversed_files(files) if params[:r]
  output_list(files)
end

def fetch_filenames_without_dotfile
  Dir.glob('*')
end

def reversed_files(files)
  files.reverse
end

def output_list(files, max_column = 3)
  result = []
  column_size = (files.size - 1) / max_column + 1
  longest_string_length = files.max_by(&:length).length

  column_size.times do |i|
    row = []
    max_column.times do
      files[i] = files[i].ljust(longest_string_length)
      row << files[i]
      i += column_size
    end
    result << row.compact.join(' ')
  end
  puts result
end

main
