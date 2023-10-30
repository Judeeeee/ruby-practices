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

def count_line(file_data)
  file_data.count("\n")
end

def count_word(file_data)
  file_data.split(' ').size
end

def count_bytesize(file_data)
  file_data.bytesize
end

def determine_caluculate(key, file_data)
    case key
    when :l
      count_line(file_data)
    when :w
      count_word(file_data)
    when :c
      count_bytesize(file_data)
    end
end

def main
  files = ARGV
  options = define_options
  if stand_alone?
    file_datas = files.map do |file|
      File.read(File.expand_path(file))
    end
  else
    file_datas = [$stdin.to_a.join]
  end

  total_hash = {l: 0, w: 0, c: 0}

  file_datas.each_with_index do |file_data, index|
    file_name = files[index]
    # オプションの有無判定
    if options.empty?
      # オプションが指定されない場合
      number_of_line = count_line(file_data)
      nuber_of_word = count_word(file_data)
      nuber_of_bytesize = count_bytesize(file_data)
      no_option_hash = {l: number_of_line, w: nuber_of_word, c: nuber_of_bytesize}

      puts "#{ no_option_hash.map { |key, value| "#{value.to_s.rjust(8)}" }.join } #{file_name}"

      # オプションが指定されない場合でファイルが複数指定された場合
      if files.size != 1
        no_option_hash.each do |key, value|
          total_hash[key] = total_hash[key] + no_option_hash[key]
        end
      end

    else
      # オプションが指定された場合
      options.each do |key, value|
        options[key] = determine_caluculate(key, file_data)
      end

      foo = options.sort_by { |str| %i[l w c].index(str[0]) }.to_h
      puts "#{ foo.map { |key, value| "#{value.to_s.rjust(8)}" }.join } #{file_name}"

      # オプションが指定された場合でファイルが複数指定された場合
      if files.size != 1
        options.each do |key, value|
          total_hash[key] = total_hash[key] + options[key]
        end
      end
    end
  end

  # ファイルが複数指定された場合は、"total"の行を出力する
  if file_datas.size != 1
    # 並び替える
    foo = total_hash.sort_by { |str| %i[l w c].index(str[0]) }.to_h.delete_if{ |key, value| value == 0 }
    puts "#{ foo.map { |key, value| "#{value.to_s.rjust(8)}" }.join } total"
  end
end

main
