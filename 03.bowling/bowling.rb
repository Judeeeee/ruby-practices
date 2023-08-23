# frozen_string_literal: true

def main
  scoreboard = ARGV[0]
  frames = split_by_frames(scoreboard)
  final_score = calculate_score(frames)
  output_result(final_score)
end

def spare?(frame)
  true if frame[0] + frame[1] == 10
end

def strike?(frame)
  true if frame[0] == 10
end

def change_last_frame(frames, last_frame)
  (last_frame + frames[10]).delete_if(&:zero?)
end

def split_by_frames(scoreboard)
  scores = scoreboard.split(',')

  shots = scores.flat_map do |score|
    score == 'X' ? [10, 0] : score.to_i
  end

  frames = shots.each_slice(2).to_a
  last_frame = frames[9]

  # 最後のフレームがスペアかストライクの場合、この後のcalculate_scoreで扱いやすいように最後のフレームを3shotsにまとめる
  frames = frames[0..-3].push(change_last_frame(frames, last_frame)) if spare?(last_frame)
  frames = frames[0..-3].push(change_last_frame(frames, last_frame)) if strike?(last_frame) && frames[10]
  frames
end

def calculate_score(frames)
  final_score = 0

  frames.each_with_index do |frame, i|
    final_score += frame.sum
    next_frame = frames[i + 1]
    two_positions_away_frame = frames[i + 2]

    break if i == frames.size - 1

    # スペアのフレームの得点は次の1投の点を加算するルール。
    final_score += next_frame[0] if spare?(frame) && !strike?(frame)

    next unless strike?(frame)

    # ストライクのフレームの得点は次の2投の点を加算するルール。
    final_score += if next_frame == [10, 0]
                     next_frame[0] + two_positions_away_frame[0]
                   else
                     next_frame[0] + next_frame.fetch(1, 0)
                   end
  end
  final_score
end

# スコア合計を標準出力。putsで引数を出力しているだけだが、テストコードで実行結果を確認するために、敢えてメソッドにしている。
def output_result(final_score)
  puts final_score
end

main if __FILE__ == $PROGRAM_NAME
