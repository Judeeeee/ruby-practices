# frozen_string_literal: true

class Frame
  def initialize(shots)
    @shots = shots
  end

  def strike?
    @shots[0].x?
  end

  def spare?
    !strike? && (total == 10)
  end

  def total
    @shots.sum(&:to_i)
  end

  def first_shot
    @shots[0].to_i
  end

  def two_shots_total
    @shots[0..1].sum(&:to_i)
  end
end
