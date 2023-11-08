# frozen_string_literal: true

require 'optparse'

def define_options
  opt = OptionParser.new
  params = {}
  opt.on('-l') { |v| params[:l] = v }
  opt.on('-w') { |v| params[:w] = v }
  opt.on('-c') { |v| params[:c] = v }
  opt.parse!(ARGV)
  if params.empty?
    params = {
      :l=>true,
      :w=>true,
      :c=>true
    }
  end
  params
end

def stand_alone?
  $stdin.isatty
end

def create_detail_line(options, string_of_file)
  detail_line = { l: 0, w: 0, c: 0 }
  options.each do |option, _selected_option|
    detail_line[option] = determine_caluculate(option, string_of_file)
  end
  detail_line.delete_if { |_option, counted_detail| counted_detail.zero? }
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

def output_lines(file_details)
  file_details.map { |_option, counted_file_detail| counted_file_detail.to_s.rjust(8) }.join
end

def calculate_total(file_detail)
  file_detail.keys.each do |option|
    file_details_total[option] += file_detail[option]
  end
end

def output_total_line(file_details_total)
  sorted_file_details = file_details_total.delete_if { |_option, counted_detail| counted_detail.zero? }
  puts "#{output_lines(sorted_file_details)} total"
end

def main
  options = define_options

  if stand_alone?
    files = ARGV
    file_details = files.to_h {|file| [file, File.read(File.expand_path(file))]}
    file_details_total = { l: 0, w: 0, c: 0 }

    file_details.each do |file_name, file_string|
      detail_line = create_detail_line(options, file_string)
      puts "#{output_lines(detail_line)} #{file_name}"

      if file_details.keys.size != 1
        options.keys.each do |option|
          file_details_total[option] += detail_line[option]
        end
      end
    end
    output_total_line(file_details_total) if file_details.size != 1
  else
    detail_line = create_detail_line(options, $stdin.to_a.join)
    puts "#{output_lines(detail_line)}"
  end
end

main
