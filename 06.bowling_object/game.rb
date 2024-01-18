# frozen_string_literal: true

class Game
  def self.create(scoreboard)
    points = scoreboard.split(',')
    shots = points.map { |point| Shot.new(point) }
    frames = create_frames(shots)
    new(frames)
  end

  def self.create_frames(shots)
    i = 0
    frames = []
    10.times do |frame_number|
      len = if frame_number == 9
              3
            elsif shots[i].strike?
              1
            else
              2
            end
      frames << Frame.new(shots[i, len])
      i += len
    end
    frames
  end

  private_class_method :create_frames

  def initialize(frames)
    @frames = frames
  end

  def total_score
    base_score = @frames.sum(&:knocked_pins_total)
    bonus_score = calculate_bonus_score_exclude_final_frame
    base_score + bonus_score
  end

  private

  def calculate_bonus_score_exclude_final_frame
    @frames.slice(0, 9).each_with_index.sum do |frame, index|
      next_frame = @frames[index + 1]
      after_next_frame = @frames[index + 2]

      if frame.spare?
        next_frame.first_shot
      elsif frame.strike?
        if next_frame.strike? && !after_next_frame.nil?
          next_frame.first_shot + after_next_frame.first_shot
        else
          next_frame.two_shots_total
        end
      else
        0
      end
    end
  end
end
