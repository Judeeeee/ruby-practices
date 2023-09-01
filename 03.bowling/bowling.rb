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
  else
    grouped_3_shots = (last_frame + last_frame_added_shot).reject(&:zero?)
  end
  return grouped_3_shots
end

def split_by_frames(scoreboard)
  scores = scoreboard.split(',')

  shots = scores.flat_map do |score|
    score == 'X' ? [10, 0] : score.to_i
  end

  frames = shots.each_slice(2).to_a
  return frames
end

def calculate_score(frames)
  #1~9フレーム
  final_score = 0
  frames[0..8].each_with_index.sum do |frame, i|
    next_frame = frames[i + 1]
    after_next_frame = frames[i + 2]

    if spare?(frame)
      final_score += frame.sum + next_frame[0]
    elsif strike?(frame)
      final_score += if strike?(next_frame)
                       frame.sum + next_frame[0] + after_next_frame[0]
                     else
                       frame.sum + next_frame[0..1].sum
                     end
    else
      final_score += frame.sum
    end
  end

  #最終フレーム
  if frames.size == 10#最後のフレームがスペアでもストライクでもない場合
    final_score += frames[9].sum
  end
  if frames.size > 10
    last_frame = frames[9]
    last_frame_added_shot = frames[10]
    grouped_3_shots = group_last_frame_shots(frames, last_frame, last_frame_added_shot)
    final_score += grouped_3_shots.sum
  end
  pp final_score
end

# スコア合計を標準出力。putsで引数を出力しているだけだが、テストコードで実行結果を確認するために、敢えてメソッドにしている。
def output_result(final_score)
  puts final_score
end

main if __FILE__ == $PROGRAM_NAME
