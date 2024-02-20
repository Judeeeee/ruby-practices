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

  def display
    if @options.include?(:l)
      max_blocks = @contents.sum(&:blocks)
      rjust_blank_sizes = calcurate_add_blank_sizes # 良い変数名が思いつかず、しっくりきていないです。。
      output_detail_lines(max_blocks,rjust_blank_sizes)
    else
      @contents.map { |content| content.path.length }.max
    end
  end

  private

  def calcurate_add_blank_sizes
    max_hardlink = @contents.map { |content| content.hardlink.size }.max
    max_owner_name = @contents.map { |content| content.owner_name.length }.max
    max_group_name = @contents.map { |content| content.group_name.length }.max
    max_bytesize = @contents.map { |content| content.bytesize.size }.max

    {
      hardlink: max_hardlink,
      owner_name: (max_owner_name + 1),
      group_name: max_group_name,
      bytesize: max_bytesize
    }
  end


  def output_detail_lines(max_blocks,rjust_blank_sizes)
    puts "total #{max_blocks}"

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

  def format_lines(lines, max_column = 3)
    row_size = (lines.size.to_f / max_column).ceil
    add_blank_size = (row_size * max_column) - lines.size
    formatted_lines = (lines + [nil] * add_blank_size).each_slice(row_size).to_a.transpose
    formatted_lines.map { |formatted_line| formatted_line.join('   ') }
  end
end
