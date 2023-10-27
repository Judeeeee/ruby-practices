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

def l_option(file_data)
  file_data.count("\n")
end

def w_option(file_data)
  file_data.split(' ').size
end

def c_option(file_data)
  file_data.bytesize
end

def calculate_total_detail_datas(file_datas)
  calculate_total_line = file_datas.sum { |file_data| l_option(file_data) }
  calculate_total_word = file_datas.sum { |file_data| w_option(file_data) }
  calculate_total_bytesize = file_datas.sum { |file_data| c_option(file_data) }

  [calculate_total_line, calculate_total_word, calculate_total_bytesize]
end

def option?(file_datas, params_array, total_line, total_word, total_bytesize)
  file_datas.each do |file_data|

    if params_array.empty?
      puts "#{[l_option(file_data).to_s.rjust(8), w_option(file_data).to_s.rjust(8), c_option(file_data).to_s.rjust(8)].join} #ファイル名"
    else
      output_line = create_end_line(params_array, total_line, total_word, total_bytesize)
      puts "#{output_line.join} #ファイル名"
    end
  end
end

def create_end_line(params_array, total_line, total_word, total_bytesize)
  end_line = []
  end_line << total_line.to_s.rjust(8) if params_array.include?('l')
  end_line << total_word.to_s.rjust(8) if params_array.include?('w')
  end_line << total_bytesize.to_s.rjust(8) if params_array.include?('c')
end

def add_end_line(params_array, total_line, total_word, total_bytesize)
  if params_array.empty?
    puts "#{[total_line.to_s.rjust(8), total_word.to_s.rjust(8), total_bytesize.to_s.rjust(8)].join} total"
  else
    end_line = create_end_line(params_array, total_line, total_word, total_bytesize)
    puts "#{end_line.join} total"
  end
end

def main
  files = ARGV
  file_datas = files.map do |file|
    File.read(File.expand_path(file))
  end
  params = define_options
  params_array = params.keys.to_a.map(&:to_s).sort_by { |str| %w[l w c].index(str) }
  input_flag = $stdin.isatty
  total_line, total_word, total_bytesize = calculate_total_detail_datas(file_datas)

  if input_flag
    option?(file_datas, params_array, total_line, total_word, total_bytesize)
    add_end_line(params_array, total_line, total_word, total_bytesize) if files.size > 1
  else
    file_data = $stdin.to_a.join
    if params_array.empty?
      puts [l_option(file_data).to_s.rjust(8), w_option(file_data).to_s.rjust(8), c_option(file_data).to_s.rjust(8)].join
    else
      output_line = create_end_line(params_array, total_line, total_word, total_bytesize)
      puts output_line.join
    end
  end
end

main
