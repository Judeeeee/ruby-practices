# frozen_string_literal: true

class Frame
  def initialize(shots)
    @shots = shots
  end

  def strike?
    @shots == [10, 0]
  end

  def spare?
    !strike? && (@shots.sum == 10)
  end

  def first_shot
    @shots[0]
  end

  def total_shot
    @shots.sum
  end
end
