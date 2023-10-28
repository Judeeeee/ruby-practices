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

def count_line(file_data)
  file_data.count("\n")
end

def count_word(file_data)
  file_data.split(' ').size
end

def count_bytesize(file_data)
  file_data.bytesize
end

def create_detail_line(params_array, file_data)
  number_of_line = count_line(file_data).to_s.rjust(8)
  nuber_of_word = count_word(file_data).to_s.rjust(8)
  nuber_of_bytesize = count_bytesize(file_data).to_s.rjust(8)

  if params_array.empty?
    [number_of_line, nuber_of_word, nuber_of_bytesize]
  else
    params_array.map do |param|
      case param
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


def display_detail_line(files, file_datas, params_array)
  file_datas.each_with_index do |file_data, i|
    file_name = files[i]
    detail_line = create_detail_line(params_array, file_data)
    puts "#{detail_line.join} #{file_name}"
  end
end

def display_total_line(params_array, file_datas)
  total_number_of_lines = file_datas.sum { |file_data| count_line(file_data) }.to_s.rjust(8)
  total_number_of_words = file_datas.sum { |file_data| count_word(file_data) }.to_s.rjust(8)
  total_number_of_bytesize = file_datas.sum { |file_data| count_bytesize(file_data) }.to_s.rjust(8)

  if params_array.empty?
    [total_number_of_lines, total_number_of_words, total_number_of_bytesize]
  else
    params_array.map do |param|
      case param
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
  params = define_options
  file_datas = files.map do |file|
    File.read(File.expand_path(file))
  end

  params_array = params.keys.to_a.map(&:to_s).sort_by { |str| %w[l w c].index(str) }
  input_flag = $stdin.isatty

  if input_flag
    display_detail_line(files, file_datas, params_array)
    puts display_total_line(params_array, file_datas).join + "total" if files.size > 1
  else
    file_data = $stdin.to_a.join
    puts create_detail_line(params_array, file_data).join
  end
end

main
