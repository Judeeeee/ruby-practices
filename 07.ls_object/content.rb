# frozen_string_literal: true

require 'etc'
require 'date'
require 'pathname'

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

  attr_reader :path

  def initialize(path)
    @path = path
    absolute_path = File.expand_path(path)
    @properties = File.stat(absolute_path)
  end

  def blocks
    @properties.blocks
  end

  def properties
    string_bytesize = bytesize.to_s
    string_hardlink = hardlink.to_s
    {
      permission:,
      hardlink: string_hardlink,
      owner_name:,
      group_name:,
      bytesize: string_bytesize,
      timestamp:,
      path:
    }
  end

  def permission
    permission = @properties.mode.to_s(8).slice(-3..-1)
    symbols = permission.each_char.map { |char| PERMISSION_SYMBOLS[char] }
    [file_mode, *symbols, '@'].join
  end

  def file_mode
    FILE_MODES[@properties.ftype]
  end

  def hardlink
    @properties.nlink
  end

  def owner_name
    Etc.getpwuid(@properties.uid).name
  end

  def group_name
    Etc.getgrgid(@properties.gid).name
  end

  def bytesize
    @properties.size
  end

  def timestamp
    @properties.mtime
  end
end
