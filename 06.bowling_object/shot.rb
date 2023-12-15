# frozen_string_literal: true

class Shot
  def initialize(point)
    @point = point
  end

  def to_i
    x? ? 10 : @point.to_i
  end

  def x?
    @point == 'X'
  end
end
