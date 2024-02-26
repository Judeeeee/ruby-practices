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
      rjust_blank_sizes = calcurate_add_blank_sizes # 良い変数名が思いつかず、しっくりきていないです。。
      output_detail_lines(total_block_size, rjust_blank_sizes)
    else
      max_path = @contents.map { |content| content.path.length }.max
      lines = @contents.map { |content| content.path.ljust(max_path) }
      output_three_column_format(lines)
    end
  end

  private

  def calcurate_add_blank_sizes
    max_hardlink = @contents.map { |content| content.hardlink.to_s.size }.max
    max_owner_name = @contents.map { |content| content.owner_name.length }.max
    max_group_name = @contents.map { |content| content.group_name.length }.max
    max_bytesize = @contents.map { |content| content.bytesize.to_s.size }.max

    {
      hardlink: max_hardlink,
      owner_name: max_owner_name,
      group_name: max_group_name,
      bytesize: max_bytesize
    }
  end

  def output_detail_lines(total_block_size, rjust_blank_sizes)
    puts "total #{total_block_size}"

    @contents.each do |content|
      properties = content.properties
      formatted_line = {}
      properties.each_key do |key|
        formatted_line[key] = if rjust_blank_sizes[key]
                                properties[key].rjust(rjust_blank_sizes[key])
                              else
                                properties[key]
                              end
      end
      puts formatted_line.values.join(' ')
    end
  end

  def output_three_column_format(lines, max_column = 3)
    row_size = (lines.size.to_f / max_column).ceil
    add_blank_size = (row_size * max_column) - lines.size
    formatted_lines = (lines + [nil] * add_blank_size).each_slice(row_size).to_a.transpose
    three_column_format_lines = formatted_lines.map { |formatted_line| formatted_line.join('   ') }
    puts three_column_format_lines
  end
end
