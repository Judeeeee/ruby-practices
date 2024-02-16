# frozen_string_literal: true

class Content
  PERMISSION_SYMBOLS = {
    '7' => 'rwx',
    '6' => 'rw-',
    '5' => 'r-x',
    '4' => 'r--',
    '3' => '-wx',
    '2' => '-w-',
    '1' => '--x',
    '0' => '---'
  }.freeze

  FILE_MODES = {
    'fifo' => 'p',
    'characterSpecial' => 'c',
    'directory' => 'd',
    'blockSpecial' => 'b',
    'file' => '-',
    'link' => 'l',
    'socket' => 's'
  }.freeze

  def initialize(path)
    @path = path
    absolute_path = File.expand_path(path)
    @file = File.stat(absolute_path)
  end

  attr_reader :path

  def blocks
    @file.blocks
  end

  def detail(max_hardlink, max_owner_name, max_group_name, max_bytesize)
    [permission,
     hardlink.rjust(max_hardlink),
     owner_name.rjust(max_owner_name + 1),
     group_name.rjust(max_group_name + 1),
     bytesize.rjust(max_bytesize),
     timestamp,
     path]
  end

  def permission
    permission = @file.mode.to_s(8).slice(-3..-1)
    symbols = permission.each_char.map { |char| PERMISSION_SYMBOLS[char] }
    [file_mode, *symbols, '@'].join
  end

  def file_mode
    FILE_MODES[@file.ftype]
  end

  def hardlink
    @file.nlink.to_s
  end

  def owner_name
    Etc.getpwuid(@file.uid).name
  end

  def group_name
    Etc.getgrgid(@file.gid).name
  end

  def bytesize
    @file.size.to_s
  end

  def timestamp
    @file.mtime.strftime('%_m %e %k:%M')
  end
end
