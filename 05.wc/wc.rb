# frozen_string_literal: true

require 'optparse'

# def main
#   opt = OptionParser.new
#   params = {}
#   opt.on('-l') {|v| params[:l] = v }
#   opt.on('-w') {|v| params[:w] = v }
#   opt.on('-c') {|v| params[:c] = v }
#   opt.parse!(ARGV)
#   files =  ARGV

#   l_total, w_total, c_total, output = calcurate_data(files, params)
#   if files.size > 1
#     total_output(l_total, w_total, c_total)
#   end
# end

def l_option(file,file_data,l_total)
  line_count = file_data.count("\n")
  output = "#{line_count} #{file}"
  l_total << line_count
  return output,l_total
end

def w_option(file,file_data,w_total)
  word_count = file_data.split(' ').size
  output = "#{word_count} #{file}"
  w_total << word_count
  return output,w_total
end

def c_option(file,file_path,c_total)
  file_size = File.size(file_path)
  output = "#{file_size} #{file}"
  c_total << file_size
  return output,c_total
end

# def l_and_w_option(file,file_data,l_total,w_total)
#   #l_option
#   line_count = file_data.count("\n")
#   l_total << line_count
#   #w option
#   word_count = file_data.split(' ').size
#   w_total << word_count
#   output = "#{line_count} #{word_count} #{file}"
#   return output, l_total, w_total
# end

# #オプション2つ
# def w_and_c_option(file,file_path,file_data,w_total,c_total)
#   #w option
#   word_count = file_data.split(' ').size
#   w_total << word_count
#   #c option
#   file_size = File.size(file_path)
#   c_total << file_size
#   output = "#{word_count} #{file_size} #{file}"
#   return output, w_total, c_total
# end

# def c_and_l_option(file,file_path,file_data,c_total,l_total)
#   #c option
#   file_size = File.size(file_path)
#   c_total << file_size
#   #l_option
#   line_count = file_data.count("\n")
#   l_total << line_count
#   output = "#{line_count} #{file_size} #{file}"
#   return output, c_total, l_total
# end

# def l_and_w_and_c_option(file,file_path,file_data,l_total,w_total,c_total)
#   #l option
#   line_count = file_data.count("\n")
#   l_total << line_count
#   #w option
#   word_count = file_data.split(' ').size
#   w_total << word_count
#   #c option
#   file_size = File.size(file_path)
#   c_total << file_size
#   output = "#{line_count} #{word_count} #{file_size} #{file}"
#   return output,l_total,w_total,c_total
# end

# def calcurate_data(files, params)
#   l_total = []
#   w_total = []
#   c_total = []
#   output=""

#   files.each{|file|
#     file_path = File.expand_path(file)
#     file_data = File.read(file_path)

#     #*オプションが1つの場合(ファイル1つ、複数指定の網羅)
#     if params.size == 1
#       if params[:l]
#         output,l_total = l_option(file,file_data,l_total)
#         puts output
#       elsif params[:w]
#         output,w_total = w_option(file,file_data,w_total)
#         puts output
#       elsif params[:c]
#         output,c_total = c_option(file,file_path,c_total)
#         puts output
#       end
#     end

#     #*オプションが2つの場合
#     if params.size == 2
#       if params.keys == [:l, :w] || params.keys == [:w, :l]
#         output,l_total,w_total = l_and_w_option(file,file_data,l_total,w_total)
#         puts output
#       end

#       if params.keys == [:w, :c] || params.keys == [:c, :w]
#         output,w_total,c_total = w_and_c_option(file,file_path,file_data,w_total,c_total)
#         puts output
#       end

#       if params.keys == [:c, :l] || params.keys == [:l, :c]
#         output,c_total,l_total = c_and_l_option(file,file_path,file_data,c_total,l_total)
#         puts output
#       end
#     end

#       #* オプション指定がない、またはオプション指定が3つの場合
#       if params.size == 0 || params.size == 3
#         output,l_total,w_total,c_total = l_and_w_and_c_option(file,file_path,file_data,l_total,w_total,c_total)
#         puts output
#       end
#   }
#   return l_total, w_total, c_total, output
# end

def total_output(l_total, w_total, c_total)
  #? 合計を算出する
  l_output = l_total.sum if l_total.sum != 1 && l_total.sum != 0
  w_output = w_total.sum if w_total.sum != 1 && w_total.sum != 0
  c_output = c_total.sum if c_total.sum != 1 && c_total.sum != 0
  puts "#{l_output} #{w_output} #{c_output} total"
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

  l_total = []
  w_total = []
  c_total = []
  output = ""

  files.each{|file|
    file_path = File.expand_path(file)
    file_data = File.read(file_path)

    params_array.each do |param|
      if param == "l"
        output,l_total = l_option(file,file_data,l_total)
        puts output
      elsif param == "w"
        output,w_total = w_option(file,file_data,w_total)
        puts output
      elsif param == "c"
        output,c_total =c_option(file,file_path,c_total)
        puts output
      else
        output,l_total = l_option(file,file_data,l_total)
        output,w_total = w_option(file,file_data,w_total)
        output,c_total =c_option(file,file_path,c_total)
      end
    end
  }

  if files.size > 1
    total_output(l_total, w_total, c_total)
  end
end
#二つオプションを指定したときに、一列で表示してほしい.1つのオプションを指定&複数ファイルはOK

main if __FILE__ == $PROGRAM_NAME
