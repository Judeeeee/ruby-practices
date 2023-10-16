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
      output_line = []
      file_path = File.expand_path(file)
      file_data = File.read(file_path)

      if params_array.empty? # オプション指定がない場合は、l,c,wどれも出力する
        puts [l_option(file_data).to_s.rjust(8), w_option(file_data).to_s.rjust(8), c_option(file_data).to_s.rjust(8), file.to_s].join(' ')
      else
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
        puts "#{output_line.join(' ').to_s.rjust(8)} #{file}"
      end
    end

    puts [total_line.to_s.rjust(8), total_word.to_s.rjust(8), total_bytesize.to_s.rjust(8), 'total'].join(' ') if files.size > 1 && params_array.empty?

    if files.size > 1 && params_array.any?
      total_display = []
      total_display << total_line.to_s.rjust(8) if params_array.include?('l')
      total_display << total_word.to_s.rjust(8) if params_array.include?('w')
      total_display << total_bytesize.to_s.rjust(8) if params_array.include?('c')
      total_display << 'total'
      puts total_display.join(' ') if files.size > 1
    end
  else # lsコマンドでパイプライン処理している場合
    output_line = []
    file_data = $stdin.to_a.join
    if params_array.empty? # オプション指定がない場合
      puts [l_option(file_data).to_s.rjust(8), w_option(file_data).to_s.rjust(8), c_option(file_data).to_s.rjust(8)].join
    else
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
      puts output_line.join
    end
  end
end

main if __FILE__ == $PROGRAM_NAME
