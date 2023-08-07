# frozen_string_literal: true

def main
  files = no_option_directory_item
  output_list(files)
end

def no_option_directory_item
  Dir.glob('*')
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

