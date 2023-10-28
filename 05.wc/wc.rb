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

def create_output_line_with_options(params_array, file_data)
  if params_array.empty?
    [count_line(file_data).to_s.rjust(8), count_word(file_data).to_s.rjust(8), count_bytesize(file_data).to_s.rjust(8)]
  else
    params_array.map do |param|
      case param
      when 'l'
        count_line(file_data).to_s.rjust(8)
      when 'w'
        count_word(file_data).to_s.rjust(8)
      when 'c'
        count_bytesize(file_data).to_s.rjust(8)
      end
    end
  end
end


def output_detail_line(files, file_datas, params_array)
  file_datas.each_with_index do |file_data, i|
    file_name = files[i]
    output_line = create_output_line_with_options(params_array, file_data)
    puts "#{output_line.join} #{file_name}"
  end
end

def create_end_line(params_array,file_datas)
  params_array.map do |param|
    case param
    when 'l'
      file_datas.sum { |file_data| count_line(file_data) }.to_s.rjust(8)
    when 'w'
      file_datas.sum { |file_data| count_word(file_data) }.to_s.rjust(8)
    when 'c'
      file_datas.sum { |file_data| count_bytesize(file_data) }.to_s.rjust(8)
    end
  end
end

def display_total_line(params_array, file_datas)
  if params_array.empty?
    [file_datas.sum { |file_data| count_line(file_data) }.to_s.rjust(8), file_datas.sum { |file_data| count_word(file_data) }.to_s.rjust(8), file_datas.sum { |file_data| count_bytesize(file_data) }.to_s.rjust(8)]
  else
    create_end_line(params_array,file_datas)
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
    output_detail_line(files, file_datas, params_array)
    puts display_total_line(params_array, file_datas).join + "total" if files.size > 1
  else
    file_datas = $stdin.to_a.join
    puts display_total_line(params_array, file_datas)
  end
end

main
