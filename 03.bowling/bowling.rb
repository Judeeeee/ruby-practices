# frozen_string_literal: true

def main
  results = ARGV[0]
  flames = convert(results)
  calculate_score(flames)
end

def convert(results)
  shots = []
  results = results.split(',')

  results.each do |result|
    result == 'X' ? shots << 10 << 0 : shots << result.to_i
  end

  # フレームごとに分割する
  flames = shots.each_slice(2).to_a

  # 最後の10投目で、スペアの場合。
  if flames[9][0] + flames[9][1] == 10
    last_flame = (flames[9] + flames[10]).delete_if(&:zero?)
    flames = flames[0..-3] << last_flame
  end

  # 最後の10投目で、ストライクの場合。
  if flames[9][0] == 10 && flames[10]
    last_flame = (flames[9] + flames[10]).delete_if(&:zero?)
    flames = flames[0..-3] << last_flame
  end
  flames
end

def calculate_score(flames)
  final_score = 0

  flames.each_with_index do |flame, i|
    final_score += flame.sum

    break if i == flames.size - 1

    # このフレームがスペアの場合
    final_score += flames[i + 1][0] if flame[0] + flame[1] == 10 && flame[0] != 10

    next if flame[0] != 10

    # このフレームがストライクの場合
    final_score += if flames[i + 1] == [10, 0]
                     flames[i + 1][0] + flames[i + 2][0]
                   else
                     flames[i + 1][0] + flames[i + 1].fetch(1, 0)
                   end
  end
  final_score
end

# #スコア合計を標準出力
def output_result(final_score)
  puts final_score
end

main if __FILE__ == './bowling'
