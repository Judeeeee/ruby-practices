# frozen_string_literal: true

require 'optparse'
require 'etc'
require 'date'
require 'pathname'

def main
  opt = OptionParser.new
  params = {}
  opt.on('-l') { |v| params[:l] = v }
  opt.parse!(ARGV)
  files = fetch_filenames_without_dotfile

  if params[:l]
    output_detail_list(files)
  else
    output_list(files)
  end
end

def fetch_filenames_without_dotfile
  Dir.glob('*')
end

def search_max_hardlink(files)
  files.map do |file|
    path = File.expand_path(file)
    count_hardlink(path).to_s.length
  end.max
end

def search_max_owner_name(files)
  files.map do |file|
    path = File.expand_path(file)
    find_owner_name(path).length
  end.max
end

def search_max_group_name(files)
  files.map do |file|
    path = File.expand_path(file)
    find_group_name(path).length
  end.max
end

def search_max_bytesize(files)
  files.map do |file|
    path = File.expand_path(file)
    calculate_bytesize(path).to_s.length
  end.max
end

def find_largest_string(files)
  max_hardlink = search_max_hardlink(files)
  max_owner_name = search_max_owner_name(files)
  max_group_name = search_max_group_name(files)
  max_bytesize = search_max_bytesize(files)
  [max_hardlink, max_owner_name, max_group_name, max_bytesize]
end

def output_detail_list(files)
  lines = []
  total_block_size = 0
  max_hardlink, max_owner_name, max_group_name, max_bytesize = find_largest_string(files)

  files.each do |file|
    path = File.expand_path(file)
    total_block_size += File.stat(path).blocks
    xattr_result = `xattr #{file}`

    line = [
      xattr_result ? change_file_permission_format(path) << '@' : change_file_permission_format(path),
      count_hardlink(path).rjust(max_hardlink),
      find_owner_name(path).ljust(max_owner_name),
      find_group_name(path).ljust(max_group_name),
      calculate_bytesize(path).rjust(max_bytesize),
      export_timestamp(path),
      file
    ].join(' ')

    lines << line
  end
  first_line = "total #{total_block_size}"
  puts lines.unshift(first_line)
end

def get_file_mode(path)
  file_mode = File.lstat(path).mode.to_s(8).slice(0..1)
  file_mode = 'd' if file_mode.to_i == 40
  file_mode = '-' if file_mode.to_i == 10
  file_mode
end

def get_permission(path)
  permission_alphabets = []
  permission = File.stat(path).mode.to_s(8).slice(-3..-1)
  permission.each_char do |char|
    permission_mode = []
    permission_mode << (char.to_i >= 4 ? 'r' : '-')
    permission_mode << ((char.to_i % 4) >= 2 ? 'w' : '-')
    permission_mode << (char.to_i.odd? ? 'x' : '-')
    permission_alphabets << permission_mode.join('')
  end
  permission_alphabets
end

def change_file_permission_format(path)
  file_mode = get_file_mode(path)
  permission = get_permission(path)
  permission.unshift(file_mode).join
end

def count_hardlink(path)
  File.stat(path).nlink.to_s
end

def find_owner_name(path)
  Etc.getpwuid(File.stat(path).uid).name
end

def find_group_name(path)
  Etc.getgrgid(File.stat(path).gid).name
end

def calculate_bytesize(path)
  File.stat(path).size.to_s
end

def export_timestamp(path)
  atime = File.stat(path).atime.to_s
  datetime = DateTime.parse(atime)
  formatted_time = "#{datetime.month} #{datetime.day} #{datetime.hour}:#{datetime.minute.to_s.rjust(2, '0')}"
  formatted_time.to_s
end

def output_list(files, max_column = 3)
  result = []
  column_size = (files.size - 1) / max_column + 1
  longest_string_length = files.max_by(&:length).length
  column_size.times do |i|
    row = []
    max_column.times do
      files[i] = files[i].ljust(longest_string_length)
      row << files[i]
      i += column_size
    end
    result << row.compact.join(' ')
  end
  puts result
end

main
