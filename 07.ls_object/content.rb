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
    @lstat = File.stat(absolute_path)
  end

  def blocks
    @lstat.blocks
  end

  def permission
    permission = @lstat.mode.to_s(8).slice(-3..-1)
    symbols = permission.each_char.map { |char| PERMISSION_SYMBOLS[char] }
    [file_mode, *symbols, '@'].join
  end

  def file_mode
    FILE_MODES[@lstat.ftype]
  end

  def hardlink
    @lstat.nlink
  end

  def owner_name
    Etc.getpwuid(@lstat.uid).name
  end

  def group_name
    Etc.getgrgid(@lstat.gid).name
  end

  def bytesize
    @lstat.size
  end

  def timestamp
    @lstat.mtime
  end
end
