# frozen_string_literal: true

require 'optparse'

def main
  options = define_options

  if stand_alone?
    files = ARGV
    file_details = files.to_h { |file| [file, File.read(File.expand_path(file))] }
    file_details_total = Hash.new(0)

    file_details.each do |file_name, file_text|
      detail_line = create_details(file_text, options)
      puts "#{add_space(detail_line)} #{file_name}"

      options.each do |option|
        file_details_total[option] += detail_line[option]
      end
    end

    puts "#{add_space(file_details_total)} total" if file_details.size > 1
  else
    detail_line = create_details($stdin.to_a.join, options)
    puts add_space(detail_line)
  end
end

def create_details(file_text, options)
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
