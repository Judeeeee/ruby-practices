# frozen_string_literal: true

require 'optparse'

def main
  options = define_options

  if stand_alone?
    files = ARGV
    file_details = files.to_h { |file| [file, File.read(File.expand_path(file))] }
    file_details_total = Hash.new(0)

    file_details.each do |file_name, file_text|
      detail_line = create_detail_line(options, file_text)
      puts "#{output_lines(detail_line)} #{file_name}"

      options.each do |option|
        file_details_total[option] += detail_line[option]
      end
    end

    output_total_line(file_details_total) if file_details.size > 1
  else
    detail_line = create_detail_line(options, $stdin.to_a.join)
    puts output_lines(detail_line)
  end
end

def create_detail_line(options, file_text)
  {
    l: count_line(file_text),
    w: count_word(file_text),
    c: count_bytesize(file_text)
  }.slice(*options)
end

def determine_caluculate(option, file_text)
  case option
  when :l
    count_line(file_text)
  when :w
    count_word(file_text)
  when :c
    count_bytesize(file_text)
  end
end

def count_line(file_text)
  file_text.count("\n")
end

def count_word(file_text)
  file_text.split(' ').size
end

def count_bytesize(file_text)
  file_text.bytesize
end

def output_total_line(file_details_total)
  puts "#{output_lines(file_details_total)} total"
end

def output_lines(file_details)
  file_details.values.map { |count| count.to_s.rjust(8) }.join
end

def define_options
  opt = OptionParser.new
  params = { l: nil, w: nil, c: nil }
  opt.on('-l') { |v| params[:l] = v }
  opt.on('-w') { |v| params[:w] = v }
  opt.on('-c') { |v| params[:c] = v }
  opt.parse!(ARGV)
  if params.values.none?
    params.transform_values { true }.keys
  else
    params.compact.keys
  end
end

def stand_alone?
  $stdin.isatty
end

main
