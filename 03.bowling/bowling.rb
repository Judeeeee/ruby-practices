# frozen_string_literal: true

def main
  scoreboard = ARGV[0]
  frames = split_by_frames(scoreboard)
  final_score = calculate_score(frames)
  output_result(final_score)
end

def strike?(frame)
  frame == [10, 0]
end

def spare?(frame)
  !strike?(frame) && (frame[0] + frame[1] == 10)
end

def split_by_frames(scoreboard)
  scores = scoreboard.split(',')

  shots = scores.flat_map do |score|
    score == 'X' ? [10, 0] : score.to_i
  end

  shots.each_slice(2).to_a
end

def detect_bonus_score(frames, frame, index)
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
  final_score = 0

  frames[0..8].each_with_index.sum do |frame, index|
    bonus_score = detect_bonus_score(frames, frame, index)
    final_score += frame.sum + bonus_score
  end

  last_frame = frames[9]
  final_score += last_frame.sum
end

# スコア合計を標準出力。putsで引数を出力しているだけだが、テストコードで実行結果を確認するために、敢えてメソッドにしている。
def output_result(final_score)
  puts final_score
end

main if __FILE__ == $PROGRAM_NAME
