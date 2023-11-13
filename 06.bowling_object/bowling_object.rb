# frozen_string_literal: true

class Shot
  def initialize(mark)
    @mark = mark
  end

  def x_to_10
    @mark == 'X' ? [10, 0] : @mark.to_i
  end
end


class Frame
  def initialize(shots)
    @shots = shots
  end

  def split_by_frames
    @shots.flatten.each.each_slice(2).to_a
  end
end


class Game
  def initialize(frames)
    @frames = frames
  end

  def calculate_score
    frame_score = @frames[0..8].flatten.sum + @frames[9..].flatten.sum
    bonus_score = caluculate_bonus_score
    frame_score + bonus_score
  end

  private

  def caluculate_bonus_score
    bonus_result = 0
    @frames[0..8].each_with_index do |frame, index|
      next_frame = @frames[index + 1]

      if spare?(frame)
        bonus_result += next_frame[0]
      elsif strike?(frame)
        if strike?(next_frame)
          after_next_frame = @frames[index + 2]
          bonus_result += next_frame[0] + after_next_frame[0]
        else
          bonus_result += next_frame[0..1].sum
        end
      else
        bonus_result += 0
      end
    end
    bonus_result
  end

  def strike?(frame)
    frame == [10, 0]
  end

  def spare?(frame)
    !strike?(frame) && (frame[0..1].sum == 10)
  end
end

def main
  scoreboard = ARGV[0].split(',')
  shots = []
  scoreboard.each do |mark|
    shots << Shot.new(mark).x_to_10
  end

  frames = Frame.new(shots).split_by_frames
  total_result = Game.new(frames)
  game_score = total_result.calculate_score
  puts game_score
end

main if __FILE__ == $PROGRAM_NAME
