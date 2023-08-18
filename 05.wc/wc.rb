# # frozen_string_literal: true
require 'optparse'
opt = OptionParser.new
params = {}

opt.on('-l') {|v| params[:l] = v }
opt.on('-w') {|v| params[:w] = v }
opt.on('-c') {|v| params[:c] = v }
opt.parse!(ARGV)
files =  ARGV

l_total = []
w_total = []
c_total = []

files.each{|file|
  file_path = File.expand_path(file)
  file_data = File.read(file_path)

  #* オプション指定がない、またはオプション指定が3つの場合
  if params.size == 0 || params.size == 3
    line_count = file_data.count("\n")
    l_total << line_count
    word_count = file_data.split(' ').size
    w_total << word_count
    file_size = File.size(file_path)
    c_total << file_size
    puts "#{line_count} #{word_count} #{file_size}"
  end

  #*オプションが1つの場合(ファイル1つ、複数指定の網羅)
  if params.size == 1
    if params[:l]
      line_count = file_data.count("\n")
      puts "#{line_count} #{file}"
      l_total << line_count
    elsif params[:w]
      word_count = file_data.split(' ').size
      puts "#{word_count} #{file}"
      w_total << word_count
    elsif params[:c]
      file_size = File.size(file_path)
      puts "#{file_size} #{file}"
      c_total << file_size
    end
  end

  #*オプションが2つの場合
  if params.size == 2
    if params.keys == [:l, :w] || params.keys == [:w, :l]
      line_count = file_data.count("\n")
      word_count = file_data.split(' ').size
      puts "#{line_count} #{word_count} #{file}"
    end

    if params.keys == [:w, :c] || params.keys == [:c, :w]
      word_count = file_data.split(' ').size
      file_size = File.size(file_path)
      puts "#{word_count} #{file_size} #{file}"
    end

    if params.keys == [:c, :l] || params.keys == [:l, :c]
      file_size = File.size(file_path)
      line_count = file_data.count("\n")
      puts "#{line_count} #{file_size} #{file}"
    end
  end
}

#? 合計を算出する
puts"#{l_total.sum} total" if l_total.size != 1 && l_total.sum != 0
puts "#{w_total.sum} total"if w_total.sum != 1 && w_total.sum != 0
puts "#{c_total.sum} total" if c_total.sum != 1 && c_total.sum != 0
