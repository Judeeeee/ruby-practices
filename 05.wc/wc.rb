# frozen_string_literal: true

require 'optparse'

def main
  options = define_options

  if stand_alone?
    files = ARGV
    file_details = files.to_h { |file| [file, File.read(file)] }
    total_counts = Hash.new(0)

    file_details.each do |file_name, file_text|
      detail_line = create_detail_line(file_text, options)
      puts "#{add_space(detail_line)} #{file_name}"

      options.each do |option|
        total_counts[option] += detail_line[option]
      end
    end

    puts "#{add_space(total_counts)} total" if file_details.size > 1
  else
    detail_line = create_detail_line($stdin.read, options)
    puts add_space(detail_line)
  end
end

def create_detail_line(file_text, options)
  {
    l: file_text.count("\n"),
    w: file_text.split(' ').size,
    c: file_text.bytesize
  }.slice(*options)
end

def add_space(file_details)
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
