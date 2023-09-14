# frozen_string_literal: true

def main
  scoreboard = ARGV[0]
  frames = split_by_frames(scoreboard)
  final_score = calculate_score(frames)
  puts final_score
end

def strike?(frame)
  frame == [10, 0]
end

def spare?(frame)
  !strike?(frame) && (frame[0..1].sum == 10)
end

def split_by_frames(scoreboard)
  scores = scoreboard.split(',')

  shots = scores.flat_map do |score|
    score == 'X' ? [10, 0] : score.to_i
  end

  shots.each_slice(2).to_a
end

def detect_bonus_score(frames, index)
  frame = frames[index]
  next_frame = frames[index + 1]

  if spare?(frame)
    next_frame[0]
  elsif strike?(frame)
    if strike?(next_frame)
      after_next_frame = frames[index + 2]
      next_frame[0] + after_next_frame[0]
    else
      next_frame[0..1].sum
    end
  else
    0
  end
end

def calculate_score(frames)
  final_score = frames[0..8].each_with_index.sum do |frame, index|
    bonus_score = detect_bonus_score(frames, index)
    frame.sum + bonus_score
  end

  last_frame = frames[9..].flatten
  final_score + last_frame.sum
end

main if __FILE__ == $PROGRAM_NAME
