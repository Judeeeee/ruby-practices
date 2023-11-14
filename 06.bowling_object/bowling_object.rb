# frozen_string_literal: true

class Shot
  def initialize(point)
    @point = point
  end

  def x_to_ten
    @point == 'X' ? [10, 0] : @point.to_i
  end
end

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

def main
  points = ARGV[0].split(',')
  x_converted_to_10_points = points.map { |point| Shot.new(point).x_to_ten }.flatten
  base_score = x_converted_to_10_points.sum
  shots = x_converted_to_10_points.each_slice(2).to_a
  frames = shots.map { |shot| Frame.new(shot) }
  bonus_score = calculate_bonus_score(frames)
  game_score = base_score + bonus_score

  puts game_score
end

def calculate_bonus_score(frames)
  bonus_score = 0
  frames.each_with_index do |frame, index|
    break if index == 9 # 最後のフレームではボーナススコアを計算しないため

    next_frame = frames[index + 1]
    after_next_frame = frames[index + 2]

    if frame.spare?
      bonus_score += next_frame.first_shot
    elsif frame.strike?
      bonus_score += if next_frame.strike?
                       next_frame.first_shot + after_next_frame.first_shot
                     else
                       next_frame.total_shot
                     end
    end
  end
  bonus_score
end

main
