# frozen_string_literal: true

class Output
  def initialize(options)
    @options = options
    paths = @options.include?(:a) ? Dir.entries('.').sort : Dir.glob('*')
    contents = paths.map { |path| Content.new(path) } # @contentsと名前が被るのですが、いい案が思いつかなかったです😓
    @contents = @options.include?(:r) ? contents.reverse : contents
  end

  def display
    if @options.include?(:l)
      total_block_size = @contents.sum(&:blocks)
      output_detail_lines(total_block_size)
    else
      pathname_widths = @contents.map { |content| content.path.length }.max
      lines = @contents.map { |content| content.path.ljust(pathname_widths) }
      output_pathname(lines)
    end
  end

  private

  def output_detail_lines(total_block_size)
    max_hardlink = find_max_hardlink
    max_owner_name = find_max_owner_name
    max_group_name = find_max_group_name
    max_bytesize = find_max_bytesize

    puts "total #{total_block_size}"
    @contents.each do |content|
      puts "#{content.permission} #{content.hardlink.to_s.rjust(max_hardlink)} #{content.owner_name.rjust(max_owner_name)}  #{content.group_name.rjust(max_group_name)}  #{content.bytesize.to_s.rjust(max_bytesize)} #{content.timestamp.strftime('%_m %e %k:%M')} #{content.path}"
    end
  end

  def find_max_hardlink
    @contents.map { |content| content.hardlink.to_s.size }.max
  end

  def find_max_owner_name
    @contents.map { |content| content.owner_name.length }.max
  end

  def find_max_group_name
    @contents.map { |content| content.group_name.length }.max
  end

  def find_max_bytesize
    @contents.map { |content| content.bytesize.to_s.size }.max
  end

  def output_pathname(lines)
    max_column = 3
    row_size = (lines.size.to_f / max_column).ceil
    blank_sizes = (row_size * max_column) - lines.size
    blank_filled_lines = lines + [nil] * blank_sizes
    formatted_lines = blank_filled_lines.each_slice(row_size).to_a.transpose
    three_column_format_lines = formatted_lines.map { |formatted_line| formatted_line.join('   ') }
    puts three_column_format_lines
  end
end
