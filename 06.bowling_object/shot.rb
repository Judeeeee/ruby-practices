# frozen_string_literal: true

class Shot
  def initialize(point)
    @point = point
  end

  def to_i
    strike? ? 10 : @point.to_i
  end

  def strike?
    @point == 'X'
  end
end
