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
  #? 合計を算出する
  l_output = l_total.sum.to_s if l_total.sum != 0
  w_output = w_total.sum.to_s if w_total.sum != 0
  c_output = c_total.sum.to_s if c_total.sum != 0
  puts [l_output,w_output,c_output,"total"].compact.join(' ')
end


def main
  opt = OptionParser.new
  params = {}
  opt.on('-l') {|v| params[:l] = v }
  opt.on('-w') {|v| params[:w] = v }
  opt.on('-c') {|v| params[:c] = v }
  opt.parse!(ARGV)
  files =  ARGV
  params_array = params.keys.to_a.map(&:to_s)

  order = ["l","w","c"]

  params_array = params_array.sort_by { |str| order.index(str) }

  l_total = []
  w_total = []
  c_total = []

  input = $stdin
  $stdin = STDIN
  input_flag = input.isatty

  if input_flag # lsコマンドでパイプライン処理していない場合(ややこしいので、tty?でもいいかも。)
    files.each { |file|
      array = []
      file_path = File.expand_path(file)
      file_data = File.read(file_path)

      if params_array == []#オプション指定がない場合
        line_count = l_option(file_data)
        word_count = w_option(file_data)
        file_size = c_option(file_data)
        l_total << line_count
        w_total << word_count
        c_total << file_size
        puts [line_count,word_count,file_size].join(' ') + " " + "#{file}"
      else
        params_array.each do |param|
          if param == "l"
            line_count = l_option(file_data)
            array << line_count
            l_total << line_count
          elsif param == "w"
            word_count = w_option(file_data)
            array << word_count
            w_total << word_count
          elsif param == "c"
            file_size = c_option(file_data)
            array << file_size
            c_total << file_size
          end
        end
        puts array.join(' ') + " " + "#{file}"
      end
    }
    if files.size > 1
      total_output(l_total, w_total, c_total)
    end
  else # lsコマンドでパイプライン処理している場合
    array = []
    file_data = $stdin.to_a.join
    if params_array == [] # オプション指定がない場合
      line_count = l_option(file_data)
      word_count = w_option(file_data)
      file_size = c_option(file_data)
      puts [line_count,word_count,file_size].join(' ')
    else
      params_array.each do |param|
        if param == "l"
          line_count = l_option(file_data)
          array << line_count
        elsif param == "w"
          word_count = w_option(file_data)
          array << word_count
        elsif param == "c"
          file_size = file_data.bytesize
          array << file_size
        end
      end
      puts array.join(' ')
    end
  end
end

main if __FILE__ == $PROGRAM_NAME
