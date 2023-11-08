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

def read_files(files)
  if stand_alone?
    files.map do |file|
      File.read(File.expand_path(file))
    end
  else
    [$stdin.to_a.join]
  end
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

def output_lines(files, file_details, file_name, total_calculation_of_file_details)
  puts "#{display_detail_line(file_details)} #{file_name}"
  calculate_total(file_details, total_calculation_of_file_details) if files.size != 1
end

def display_detail_line(file_details)
  file_details.map { |_option, counted_file_detail| counted_file_detail.to_s.rjust(8) }.join
end

def calculate_total(file_detail, total_calculation_of_file_details)
  file_detail.each do |option, _counted_file_detail|
    total_calculation_of_file_details[option] = total_calculation_of_file_details[option] + file_detail[option]
  end
end

def sort_options(options)
  options.sort_by { |option| %i[l w c].index(option[0]) }.to_h
end

def main
  options = define_options
  total_calculation_of_file_details = { l: 0, w: 0, c: 0 }
  files = ARGV
  string_of_files = read_files(files)

  string_of_files.each_with_index do |string_of_file, index|
    file_name = files[index]
    if options.empty?
      file_details = { l: count_line(string_of_file), w: count_word(string_of_file), c: count_bytesize(string_of_file) }
      output_lines(files, file_details, file_name, total_calculation_of_file_details)
    else
      detail_line = create_detail_line(options, string_of_file)
      output_lines(files, detail_line, file_name, total_calculation_of_file_details)
    end
  end

  return unless string_of_files.size != 1
  sorted_file_details = total_calculation_of_file_details.delete_if { |_option, counted_detail| counted_detail.zero? }
  puts "#{display_detail_line(sorted_file_details)} total"
end

main
