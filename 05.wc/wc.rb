# frozen_string_literal: true

require 'optparse'

def l_option(file_data)
  file_data.count("\n")
end

def w_option(file_data)
  file_data.split(' ').size
end

def c_option(file_data)
  file_data.bytesize
end

def calculate_total_line(files)
  file_datas = files.map do |file|
    File.read(File.expand_path(file))
  end
  file_datas.sum { |file_data| l_option(file_data) }
end

def calculate_total_word(files)
  file_datas = files.map do |file|
    File.read(File.expand_path(file))
  end
  file_datas.sum { |file_data| w_option(file_data) }
end

def calculate_total_bytesize(files)
  file_datas = files.map do |file|
    File.read(File.expand_path(file))
  end
  file_datas.sum { |file_data| c_option(file_data) }
end

def create_output_line_with_options(params_array,file_data)
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

# TODO: オプション指定ありで複数ファイルが渡された場合
def create_end_line(params_array,total_line,total_word,total_bytesize)
  end_line = []
  end_line << total_line.to_s.rjust(8) if params_array.include?('l')
  end_line << total_word.to_s.rjust(8) if params_array.include?('w')
  end_line << total_bytesize.to_s.rjust(8) if params_array.include?('c')
end

def main
  opt = OptionParser.new
  params = {}
  opt.on('-l') { |v| params[:l] = v }
  opt.on('-w') { |v| params[:w] = v }
  opt.on('-c') { |v| params[:c] = v }
  opt.parse!(ARGV)
  files = ARGV
  params_array = params.keys.to_a.map(&:to_s).sort_by { |str| %w[l w c].index(str) }

  input = $stdin
  $stdin = STDIN
  input_flag = input.isatty

  total_line = calculate_total_line(files)
  total_word = calculate_total_word(files)
  total_bytesize = calculate_total_bytesize(files)

  if input_flag
    files.each do |file|
      file_path = File.expand_path(file)
      file_data = File.read(file_path)

      if params_array.empty?
        puts "#{[l_option(file_data).to_s.rjust(8), w_option(file_data).to_s.rjust(8), c_option(file_data).to_s.rjust(8)].join} #{file}"
      else
        output_line = create_output_line_with_options(params_array,file_data)
        puts "#{output_line.join} #{file}"
      end
    end

    puts "#{[total_line.to_s.rjust(8), total_word.to_s.rjust(8), total_bytesize.to_s.rjust(8)].join} total" if files.size > 1 && params_array.empty?

    if files.size > 1 && params_array.any?
      end_line = create_end_line(params_array,total_line,total_word,total_bytesize)
      puts "#{end_line.join} total"
    end
  else
    file_data = $stdin.to_a.join
    if params_array.empty?
      puts [l_option(file_data).to_s.rjust(8), w_option(file_data).to_s.rjust(8), c_option(file_data).to_s.rjust(8)].join
    else
      output_line = create_output_line_with_options(params_array,file_data)
      puts output_line.join
    end
  end
end

main if __FILE__ == $PROGRAM_NAME
