# frozen_string_literal: true

class Frame
  def initialize(shots)
    @shots = shots
  end

  def strike?
    @shots[0].strike?
  end

  def spare?
    !strike? && (base_score == 10)
  end

  def base_score
    @shots.sum(&:to_i)
  end

  def first_shot
    @shots[0].to_i
  end

  def two_shots_total
    @shots[0..1].sum(&:to_i)
  end
end
