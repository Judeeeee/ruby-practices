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
  files = show_file_detail(files) if params[:l]
  puts files
end

def fetch_filenames_without_dotfile
  Dir.glob('*')
end

def show_file_detail(files)
  detail_lines = []
  total_block_size = 0
  files.each{|file|
    path = File.expand_path(file)
    total_block_size += get_file_stat(path).blocks

    line = [change_file_permission_format(path), count_hardlink(path), find_owner_name(path), find_group_name(path), calculate_bytesize(path).rjust(4), export_timestamp(path), file].join(' ')
    detail_lines << line
  }
  total_block_size = "total #{total_block_size.to_s}"
  detail_lines.unshift(total_block_size)
end

def get_file_stat(path)
  File.stat(path)
end

def get_file_mode(path)
  file_mode = File.lstat(path).mode.to_s(8).slice(0..1)
  file_mode = 'd' if file_mode.to_i == 40
  file_mode = '-' if file_mode.to_i == 10
  file_mode
end

def get_permission(path)
  final_result = []
  permission = get_file_stat(path).mode.to_s(8).slice(-3..-1)
  permission.each_char{|char|
    permission_mode = "".dup
    permission_mode << (char.to_i >= 4 ? 'r' : '-')
    permission_mode << ((char.to_i % 4) >= 2 ? 'w' : '-')
    permission_mode << ((char.to_i % 2) == 1 ? 'x' : '-')
    final_result << permission_mode
  }
  final_result << "@"
end

def change_file_permission_format(path)
  file_mode = get_file_mode(path)
  permission = get_permission(path)
  final_result = permission.unshift(file_mode)
  final_result.join
end

def count_hardlink(path)
  get_file_stat(path).nlink
end

def find_owner_name(path)
  Etc.getpwuid(get_file_stat(path).uid).name
end

def find_group_name(path)
  Etc.getgrgid(get_file_stat(path).gid).name
end

def calculate_bytesize(path)
  bytesize = get_file_stat(path).size
  bytesize.to_s
end

def export_timestamp(path)
  atime = get_file_stat(path).atime.to_s
  datetime = DateTime.parse(atime)
  formatted_time = "#{datetime.month} #{datetime.day} #{datetime.hour}:#{datetime.minute.to_s.rjust(2, '0')}"
  formatted_time.to_s
end

main
