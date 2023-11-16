# frozen_string_literal: true

class Shot
  def initialize(point)
    @point = point
  end

  def x_to_ten
    @point == 'X' ? [10, 0] : @point.to_i
  end
end
