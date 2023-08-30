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

def group_last_frame_shots(frames, last_frame, last_frame_added_shot)
  # 10フレーム目が全てストライクの場合
  if strike?(last_frame) && strike?(last_frame_added_shot)
    last_frame_final_shot = frames[11]
    grouped_3_shots = (last_frame + last_frame_added_shot + last_frame_final_shot).reject(&:zero?)
    [*frames[0..-4], grouped_3_shots]
  else
    grouped_3_shots = (last_frame + last_frame_added_shot).reject(&:zero?)
    frames[0..-3].push(grouped_3_shots)
    [*frames[0..-3], grouped_3_shots]
  end
end

def split_by_frames(scoreboard)
  scores = scoreboard.split(',')

  shots = scores.flat_map do |score|
    score == 'X' ? [10, 0] : score.to_i
  end

  frames = shots.each_slice(2).to_a
  last_frame = frames[9]
  last_frame_added_shot = frames[10]

  # 最後のフレームがスペアかストライクの場合は3投目が投げられる。この後のcalculate_scoreで扱いやすいように最後のフレームを3shotsにまとめる
  frames = group_last_frame_shots(frames, last_frame, last_frame_added_shot) if frames.size != 10
  frames
end

def calculate_score(frames)
  final_score = 0

  frames.each_with_index do |frame, i|
    final_score += frame.sum
    next_frame = frames[i + 1]
    after_next_frame = frames[i + 2]

    break if i == frames.size - 1

    if spare?(frame)
      final_score += next_frame[0]
    elsif strike?(frame)
      final_score += if strike?(next_frame)
                       next_frame[0] + after_next_frame[0]
                     else
                       next_frame[0] + next_frame.fetch(1, 0)
                     end
    end
  end
  final_score
end

# スコア合計を標準出力。putsで引数を出力しているだけだが、テストコードで実行結果を確認するために、敢えてメソッドにしている。
def output_result(final_score)
  puts final_score
end

main if __FILE__ == $PROGRAM_NAME
