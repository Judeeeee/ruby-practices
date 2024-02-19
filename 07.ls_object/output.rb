# frozen_string_literal: true

class Output
  def initialize(options)
    @options = options
    paths = if @options.include?(:a)
              Dir.entries('.').sort
            else
              Dir.glob('*')
            end

    @contents = if @options.include?(:r)
      paths.map { |path| Content.new(path) }.reverse
    else
      paths.map { |path| Content.new(path) }
    end
  end

  def max_length
    if @options.include?(:l)
      max_hardlink = @contents.map { |content| content.hardlink.size }.max
      max_owner_name = @contents.map { |content| content.owner_name.length }.max
      max_group_name = @contents.map { |content| content.group_name.length }.max
      max_bytesize = @contents.map { |content| content.bytesize.size }.max
      [max_hardlink, max_owner_name, max_group_name, max_bytesize]
    else
      @contents.map { |content| content.path.length }.max
    end
  end

  def display
    puts "total #{@contents.sum(&:blocks)}" if @options.include?(:l)
    puts create_lines(max_length)
  end

  private

  def create_lines(max_length)
    if @options.include?(:l)
      max_hardlink, max_owner_name, max_group_name, max_bytesize = max_length
      @contents.map { |content| content.detail(max_hardlink, max_owner_name, max_group_name, max_bytesize).join(' ') }
    else
      lines = @contents.map { |content| content.path.ljust(max_length) }
      format_lines(lines)
    end
  end

  def format_lines(lines, max_column = 3)
    row_size = (lines.size.to_f / max_column).ceil
    add_blank_size = (row_size * max_column) - lines.size
    formatted_lines = (lines + [nil] * add_blank_size).each_slice(row_size).to_a.transpose
    formatted_lines.map { |formatted_line| formatted_line.join('   ') }
  end
end
