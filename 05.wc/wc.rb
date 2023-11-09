# frozen_string_literal: true

require 'optparse'

def create_detail_line(options, string_of_file)
  detail_line = {}
  options.each_key do |option|
    detail_line[option] = determine_caluculate(option, string_of_file)
  end
  detail_line
end

def determine_caluculate(option, string_of_file)
  case option
  when :l
    count_line(string_of_file)
  when :w
    count_word(string_of_file)
  when :c
    count_bytesize(string_of_file)
  end
end

def count_line(string_of_file)
  string_of_file.count("\n")
end

def count_word(string_of_file)
  string_of_file.split(' ').size
end

def count_bytesize(string_of_file)
  string_of_file.bytesize
end

def output_total_line(file_details_total)
  puts "#{output_lines(file_details_total)} total"
end

def output_lines(file_details)
  file_details.values.map { |counted_file_detail| counted_file_detail.to_s.rjust(8) }.join
end

def define_options
  opt = OptionParser.new
  params = { l: nil, w: nil, c: nil }
  opt.on('-l') { |v| params[:l] = v }
  opt.on('-w') { |v| params[:w] = v }
  opt.on('-c') { |v| params[:c] = v }
  opt.parse!(ARGV)
  if params.values.none?
    params.transform_values { true }
  else
    params.compact
  end
end

def stand_alone?
  $stdin.isatty
end

def inilialize_file_details_total(options)
  file_details_total = {}
  options.each_key do |option|
    file_details_total[option] = 0
  end
  file_details_total
end

def main
  options = define_options

  if stand_alone?
    files = ARGV
    file_details = files.to_h { |file| [file, File.read(File.expand_path(file))] }
    file_details_total = inilialize_file_details_total(options)

    file_details.each do |file_name, file_string|
      detail_line = create_detail_line(options, file_string)
      puts "#{output_lines(detail_line)} #{file_name}"

      next if file_details.size == 1

      options.each_key do |option|
        file_details_total[option] += detail_line[option]
      end
    end

    output_total_line(file_details_total) if file_details.size != 1
  else
    detail_line = create_detail_line(options, $stdin.to_a.join)
    puts output_lines(detail_line)
  end
end

main
