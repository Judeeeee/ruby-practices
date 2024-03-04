# frozen_string_literal: true

class TerminalDisplay
  MAX_COLUMN = 3

  def initialize(options)
    @options = options
    paths = @options.include?(:a) ? Dir.entries('.').sort : Dir.glob('*')
    contents = paths.map { |path| Content.new(path) }
    @contents = @options.include?(:r) ? contents.reverse : contents
  end

  def output
    if @options.include?(:l)
      output_detail_lines
    else
      output_pathname
    end
  end

  private

  def output_detail_lines
    total_block_size = @contents.sum(&:blocks)
    max_hardlink = @contents.map { |content| content.hardlink.to_s.size }.max
    owner_name_width = @contents.map { |content| content.owner_name.length }.max
    group_name_width = @contents.map { |content| content.group_name.length }.max
    max_bytesize = @contents.map { |content| content.bytesize.to_s.size }.max

    puts "total #{total_block_size}"
    @contents.each do |content|
      line = [
        content.permission,
        content.hardlink.to_s.rjust(max_hardlink),
        "#{content.owner_name.rjust(owner_name_width)} ",
        "#{content.group_name.rjust(group_name_width)} ",
        content.bytesize.to_s.rjust(max_bytesize),
        content.timestamp.strftime('%_m %e %k:%M'),
        content.path
      ]
      puts line.join(' ')
    end
  end

  def output_pathname
    pathname_width = @contents.map { |content| content.path.length }.max
    lines = @contents.map { |content| content.path.ljust(pathname_width) }
    row_size = (lines.size.to_f / MAX_COLUMN).ceil
    blank_sizes = (row_size * MAX_COLUMN) - lines.size
    nill_filled_lines = lines + [nil] * blank_sizes
    grouped_row_lines = nill_filled_lines.each_slice(row_size).to_a.transpose
    puts(grouped_row_lines.map { |formatted_line| formatted_line.join('   ') })
  end
end
