# frozen_string_literal: true

require 'optparse'

def main
  options = read_options

  if stand_alone?
    files = ARGV
    file_details = files.to_h { |file| [file, File.read(file)] }
    total_counts = Hash.new(0)

    file_details.each do |file_name, file_text|
      detail_line = create_detail_line(file_text, options)
      puts "#{format_counts(detail_line)} #{file_name}"

      options.each do |option|
        total_counts[option] += detail_line[option]
      end
    end

    puts "#{format_counts(total_counts)} total" if file_details.size > 1
  else
    detail_line = create_detail_line($stdin.read, options)
    puts format_counts(detail_line)
  end
end

def create_detail_line(text, options)
  {
    l: text.count("\n"),
    w: text.split(' ').size,
    c: text.bytesize
  }.slice(*options)
end

def format_counts(file_details)
  file_details.values.map { |count| count.to_s.rjust(8) }.join
end

def read_options
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
