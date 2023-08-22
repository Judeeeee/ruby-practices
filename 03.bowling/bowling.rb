# frozen_string_literal: true

def main
  results = ARGV[0]
  frames = convert(results)
  final_score = calculate_score(frames)
  output_result(final_score)
end

def convert(results)
  shots = []
  results = results.split(',')

  results.each do |result|
    result == 'X' ? shots << 10 << 0 : shots << result.to_i
  end

  # フレームごとに分割する
  frames = shots.each_slice(2).to_a

  # 最後の10投目で、スペアの場合。
  if frames[9][0] + frames[9][1] == 10
    last_frame = (frames[9] + frames[10]).delete_if(&:zero?)
    frames = frames[0..-3] << last_frame
  end

  # 最後の10投目で、ストライクの場合。
  if frames[9][0] == 10 && frames[10]
    last_frame = (frames[9] + frames[10]).delete_if(&:zero?)
    frames = frames[0..-3] << last_frame
  end
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
