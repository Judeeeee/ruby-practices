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

def total_output(l_total, w_total, c_total)
  # ? 合計を算出する
  l_output = l_total.sum.to_s if l_total.sum != 0
  w_output = w_total.sum.to_s if w_total.sum != 0
  c_output = c_total.sum.to_s if c_total.sum != 0
  puts [l_output, w_output, c_output, 'total'].compact.join(' ')
end

def main
  opt = OptionParser.new
  params = {}
  opt.on('-l') { |v| params[:l] = v }
  opt.on('-w') { |v| params[:w] = v }
  opt.on('-c') { |v| params[:c] = v }
  opt.parse!(ARGV)
  files = ARGV
  params_array = params.keys.to_a.map(&:to_s)

  l_total = []
  w_total = []
  c_total = []

  input = $stdin
  $stdin = STDIN
  input_flag = input.isatty

  if input_flag # lsコマンドでパイプライン処理していない場合(ややこしいので、tty?でもいいかも。)
    files.each do |file|
      output_line = []
      file_path = File.expand_path(file)
      file_data = File.read(file_path)

      if params_array == [] # オプション指定がない場合は、l,c,wどれも出力する
        l_total << l_option(file_data)
        w_total << w_option(file_data)
        c_total << c_option(file_data)
        puts [l_option(file_data), w_option(file_data), c_option(file_data), file.to_s].join(' ')
      else
        params_array.each do |param|
          case param
          when 'l'
            output_line << l_option(file_data)
            l_total << l_option(file_data)
          when 'w'
            output_line << w_option(file_data)
            w_total << w_option(file_data)
          when 'c'
            output_line << c_option(file_data)
            c_total << c_option(file_data)
          end
        end
        puts "#{output_line.join(' ')} #{file}"
      end
    end
    total_output(l_total, w_total, c_total) if files.size > 1
  else # lsコマンドでパイプライン処理している場合
    output_line = []
    file_data = $stdin.to_a.join
    if params_array == [] # オプション指定がない場合
      puts [l_option(file_data), w_option(file_data), c_option(file_data)].join(' ')
    else
      params_array.each do |param|
        case param
        when 'l'
          output_line << l_option(file_data)
        when 'w'
          output_line << w_option(file_data)
        when 'c'
          output_line << c_option(file_data)
        end
      end
      puts output_line.join(' ')
    end
  end
end

main if __FILE__ == $PROGRAM_NAME
