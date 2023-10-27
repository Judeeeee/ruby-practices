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
  file_datas.size == 1 ? calculate_total_line = file_datas.sum { |file_data| l_option(file_data) } : calculate_total_line = l_option(file_datas)
  file_datas.size == 1 ? calculate_total_word = file_datas.sum { |file_data| w_option(file_data) } : calculate_total_word = w_option(file_datas)
  file_datas.size == 1 ? calculate_total_bytesize = file_datas.sum { |file_data| c_option(file_data) } : calculate_total_bytesize = c_option(file_datas)
  [calculate_total_line, calculate_total_word, calculate_total_bytesize]
end

def create_output_line_with_options(params_array, file_data)
  output_line = []
  params_array.each do |param|
    case param
    when 'l'
      output_line << l_option(file_data).to_s.rjust(8)
    when 'w'
      output_line << w_option(file_data).to_s.rjust(8)
    when 'c'
      output_line << c_option(file_data).to_s.rjust(8)
    end
  end
  output_line
end


def option?(files, file_datas, params_array)
  file_datas.each_with_index do |file_data, i|
    file_name = files[i]
    if params_array.empty?
      #オプションがない場合は3つ全てのデータを返す
      puts "#{[l_option(file_data).to_s.rjust(8), w_option(file_data).to_s.rjust(8), c_option(file_data).to_s.rjust(8)].join} #{file_name}"
    else
      # オプションがある場合は指定されたオプションのデータを返す
      output_line = create_output_line_with_options(params_array, file_data)
      puts "#{output_line.join} #{file_name}"
    end
  end
end

def create_end_line(params_array, total_line, total_word, total_bytesize)
  end_line = []
  end_line << total_line.to_s.rjust(8) if params_array.include?('l')
  end_line << total_word.to_s.rjust(8) if params_array.include?('w')
  end_line << total_bytesize.to_s.rjust(8) if params_array.include?('c')
  end_line
end



def add_end_line(params_array, total_line, total_word, total_bytesize)
  if params_array.empty?
    "#{[total_line.to_s.rjust(8), total_word.to_s.rjust(8), total_bytesize.to_s.rjust(8)].join}"
  else
    end_line = create_end_line(params_array, total_line, total_word, total_bytesize)
    "#{end_line.join}"
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
    option?(files, file_datas, params_array)
    total_line, total_word, total_bytesize = calculate_total_detail_datas(file_datas)
    puts add_end_line(params_array, total_line, total_word, total_bytesize) + "total" if files.size > 1
  else
    file_datas = $stdin.to_a.join
    total_line, total_word, total_bytesize = calculate_total_detail_datas(file_datas)
    puts add_end_line(params_array, total_line, total_word, total_bytesize)
  end
end

main
