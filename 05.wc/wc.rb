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

def count_line(string_of_file)
  string_of_file.count("\n")
end

def count_word(string_of_file)
  string_of_file.split(' ').size
end

def count_bytesize(string_of_file)
  string_of_file.bytesize
end

def determine_caluculate(key, string_of_file)
    case key
    when :l
      count_line(string_of_file)
    when :w
      count_word(string_of_file)
    when :c
      count_bytesize(string_of_file)
    end
end

def calculate_total(hash, total_calculation_of_file_details)
  hash.each do |key, value|
    total_calculation_of_file_details[key] = total_calculation_of_file_details[key] + hash[key]
  end
end

def sort_options(hash)
  hash.sort_by { |str| %i[l w c].index(str[0]) }.to_h
end

def output_lines(file_details, file_name, total_calculation_of_file_details)
  puts "#{display_detail_line(file_details)} #{file_name}"
  calculate_total(file_details, total_calculation_of_file_details) if files.size != 1
end

def display_detail_line(hash)
  hash.map { |key, value| "#{value.to_s.rjust(8)}" }.join
end

def create_detail_line(options, string_of_file)
  options.each do |key, value|
    options[key] = determine_caluculate(key, string_of_file)
  end
end

def main
  options = define_options
  total_calculation_of_file_details = {l: 0, w: 0, c: 0}
  files = ARGV
  if stand_alone?
    string_of_files = files.map do |file|
      File.read(File.expand_path(file))
    end
  else
    string_of_files = [$stdin.to_a.join]
  end

  string_of_files.each_with_index do |string_of_file, index|
    file_name = files[index]
    if options.empty?
      file_details = {l: count_line(string_of_file), w: count_word(string_of_file), c: count_bytesize(string_of_file)}
      output_lines(file_details, file_name, total_calculation_of_file_details)
    else
      create_detail_line(options, string_of_file)
      sorted_file_details = sort_options(options)
      output_lines(sorted_file_details, file_name, total_calculation_of_file_details)
    end
  end

  if string_of_files.size != 1
    sorted_file_details = sort_options(total_calculation_of_file_details).delete_if{ |option, counted_detail| counted_detail.nil? }
    puts "#{ display_detail_line(sorted_file_details) } total"
  end
end

main
