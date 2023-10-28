# frozen_string_literal: true

require 'optparse'

def define_options
  opt = OptionParser.new
  params = {}
  opt.on('-l') { |v| params[:l] = v }
  opt.on('-w') { |v| params[:w] = v }
  opt.on('-c') { |v| params[:c] = v }
  opt.parse!(ARGV)
  params
end

def stand_alone?
  $stdin.isatty
end

def display_detail_line(files, file_datas, options_array)
  file_datas.each_with_index do |file_data, index|
    file_name = files[index]
    detail_line = create_detail_line(options_array, file_data)
    puts "#{detail_line.join} #{file_name}"
  end
end

def create_detail_line(options_array, file_data)
  number_of_line = count_line(file_data).to_s.rjust(8)
  nuber_of_word = count_word(file_data).to_s.rjust(8)
  nuber_of_bytesize = count_bytesize(file_data).to_s.rjust(8)

  if options_array.empty?
    [number_of_line, nuber_of_word, nuber_of_bytesize]
  else
    options_array.map do |option|
      case option
      when 'l'
        number_of_line
      when 'w'
        nuber_of_word
      when 'c'
        nuber_of_bytesize
      end
    end
  end
end

def count_line(file_data)
  file_data.count("\n")
end

def count_word(file_data)
  file_data.split(' ').size
end

def count_bytesize(file_data)
  file_data.bytesize
end

def display_total_line(options_array, file_datas)
  total_number_of_lines = file_datas.sum { |file_data| count_line(file_data) }.to_s.rjust(8)
  total_number_of_words = file_datas.sum { |file_data| count_word(file_data) }.to_s.rjust(8)
  total_number_of_bytesize = file_datas.sum { |file_data| count_bytesize(file_data) }.to_s.rjust(8)

  if options_array.empty?
    [total_number_of_lines, total_number_of_words, total_number_of_bytesize]
  else
    options_array.map do |option|
      case option
      when 'l'
        total_number_of_lines
      when 'w'
        total_number_of_words
      when 'c'
        total_number_of_bytesize
      end
    end
  end
end

def main
  files = ARGV
  options = define_options
  file_datas = files.map do |file|
    File.read(File.expand_path(file))
  end

  options_array = options.keys.to_a.map(&:to_s).sort_by { |str| %w[l w c].index(str) }

  if stand_alone?
    display_detail_line(files, file_datas, options_array)
    puts "#{display_total_line(options_array, file_datas).join} total" if files.size > 1
  else
    file_data = $stdin.to_a.join
    puts create_detail_line(options_array, file_data).join
  end
end

main
