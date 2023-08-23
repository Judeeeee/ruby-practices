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
  shots = []
  scores = scoreboard.split(',')

  scores.each do |score|
    score == 'X' ? shots << 10 << 0 : shots << score.to_i
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

    break if i == frames.size - 1

    # このフレームがスペアの場合
    final_score += frames[i + 1][0] if frame[0] + frame[1] == 10 && frame[0] != 10

    next if frame[0] != 10

    # このフレームがストライクの場合
    final_score += if frames[i + 1] == [10, 0]
                     frames[i + 1][0] + frames[i + 2][0]
                   else
                     frames[i + 1][0] + frames[i + 1].fetch(1, 0)
                   end
  end
  final_score
end

# スコア合計を標準出力。putsで引数を出力しているだけだが、テストコードで実行結果を確認するために、敢えてメソッドにしている。
def output_result(final_score)
  puts final_score
end

main if __FILE__ == $PROGRAM_NAME
