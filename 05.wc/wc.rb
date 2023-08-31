# frozen_string_literal: true

require 'optparse'

def l_option(file_data,l_total)
  line_count = file_data.count("\n")
  l_total << line_count
  return line_count,l_total
end

def w_option(file_data,w_total)
  word_count = file_data.split(' ').size
  w_total << word_count
  return word_count,w_total
end

def c_option(file_path,c_total)
  file_size = File.size(file_path)
  c_total << file_size
  return file_size,c_total
end

def total_output(l_total, w_total, c_total)
  #? 合計を算出する
  l_output = l_total.sum.to_s if l_total.sum != 0
  w_output = w_total.sum.to_s if w_total.sum != 0
  c_output = c_total.sum.to_s if c_total.sum != 0
  #オプションが1つだと、左詰にならない。（nilが空文字判定なので)。
  #文字列にして足せばこの問題は解決するのだが、文字列同士の足し算になってしまう。
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
  #l,w,cの順番で入れ替える
  order = ["l","w","c"]

  params_array = params_array.sort_by { |str| order.index(str) }

  l_total = []
  w_total = []
  c_total = []

  #lsコマンドでパイプライン処理している場合
  if $stdin
    array = []
    file_data = $stdin.to_a.join
    if params_array == []#オプション指定がない場合
      line_count,l_total = l_option(file_data,l_total)
      word_count,w_total = w_option(file_data,w_total)
      file_size = file_data.bytesize
      puts [line_count,word_count,file_size].join(' ')
    else
      params_array.each do |param|
        if param == "l"
          line_count,l_total = l_option(file_data,l_total)
          array << line_count
        elsif param == "w"
          word_count,w_total = w_option(file_data,w_total)
          array << word_count
        elsif param == "c"
          file_size = file_data.bytesize
          array << file_size
        end
      end
      puts array.join(' ')
    end
  else
    files.each{|file|
      array = []
      file_path = File.expand_path(file)
      file_data = File.read(file_path)#=>lsコマンドで渡ってきている時は、file_data =  $stdin.to_a.joinとしたい。

      if params_array == []#オプション指定がない場合
        line_count,l_total = l_option(file_data,l_total)
        word_count,w_total = w_option(file_data,w_total)
        file_size,c_total = c_option(file_path,c_total)
        puts [line_count,word_count,file_size].join(' ') + " " + "#{file}"
      else
        params_array.each do |param|
          if param == "l"
            line_count,l_total = l_option(file_data,l_total)
            array << line_count
          elsif param == "w"
            word_count,w_total = w_option(file_data,w_total)
            array << word_count
          elsif param == "c"
            file_size,c_total =c_option(file_path,c_total)
            array << file_size
          end
        end
        puts array.join(' ') + " " + "#{file}"
      end
    }

    if files.size > 1
      total_output(l_total, w_total, c_total)
    end
  end
end

main if __FILE__ == $PROGRAM_NAME
