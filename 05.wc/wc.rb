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

# ファイルが複数指定された場合、合計を計算する
def calcllate_total(hash, total_hash)
  hash.each do |key, value|
    total_hash[key] = total_hash[key] + hash[key]
  end
end

# 行の出力
def display_detail_line(hash)
  hash.map { |key, value| "#{value.to_s.rjust(8)}" }.join
end

# オプションを並び替える
def sort_options(hash)
  hash.sort_by { |str| %i[l w c].index(str[0]) }.to_h
end

def main
  options = define_options
  total_hash = {l: 0, w: 0, c: 0}
  files = ARGV
  if stand_alone?
    file_datas = files.map do |file|
      File.read(File.expand_path(file))
    end
  else
    file_datas = [$stdin.to_a.join]
  end

  file_datas.each_with_index do |file_data, index|
    file_name = files[index]
    # オプションの有無判定
    if options.empty?
      # オプションが指定されない場合
      file_details = {l: count_line(file_data), w: count_word(file_data), c: count_bytesize(file_data)}

      puts "#{display_detail_line(file_details)} #{file_name}"

      # オプションが指定されない場合でファイルが複数指定された場合
      calcllate_total(file_details, total_hash) if files.size != 1

    else
      # オプションが指定された場合
      options.each do |key, value|
        options[key] = determine_caluculate(key, file_data)
      end

      foo = sort_options(options)
      puts "#{display_detail_line(foo)} #{file_name}"

      # オプションが指定された場合でファイルが複数指定された場合
      calcllate_total(options, total_hash) if files.size != 1
    end
  end

  # ファイルが複数指定された場合は、"total"の行を出力する
  if file_datas.size != 1
    # 並び替える
    foo = sort_options(total_hash).delete_if{ |key, value| value == 0 }
    puts "#{ display_detail_line(foo) } total"
  end
end

main
