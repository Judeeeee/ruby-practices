# frozen_string_literal: true

def main
  input = ARGV[0]
  convert(input)
  frames = convert(input)
  point = calculate_score(frames)
  output_result(point)
end

def convert(input)
  shots = []
  frames = []
  scores = input.split(',')

  scores.each do |s|
    if s == 'X'
      shots << 10
      shots << 0
    else
      shots << s.to_i
    end
  end

  # フレームごとに分割する
  shots.each_slice(2) do |n|
    frames << n
  end

  # 最後の10投目で、スペアの場合、最後の配列と結合した配列を返す。
  if frames[9][0] + frames[9][1] == 10
    tmp = (frames[9] + frames[10]).delete_if(&:zero?)
    frames = frames[0..-3]
    frames = frames << tmp
  end

  # 最後の10投目で、ストライクの場合。
  if frames[9][0] == 10 && frames[10]
    tmp = (frames[9] + frames[10]).delete_if(&:zero?)
    frames = frames[0..-3]
    frames = frames << tmp
  end
  frames
end

def calculate_score(flames)
  point = 0

  flames.each_with_index do |flame, i|
    frame_score = flame.sum
    point += frame_score

    break if i == flames.size - 1

    # このフレームがスペアの場合
    point += flames[i + 1][0] if flame[0] + flame[1] == 10 && flame[0] != 10

    # このフレームがストライクの場合
    if flame[0] == 10
      if flames[i + 1] == [10, 0]
        point += flames[i + 1][0] + flames[i + 2][0]
      else
        point += (flames[i + 1][0] + flames[i + 1].fetch(1, 0))
      end
    end
  end
  point
end

# #スコア合計を標準出力
def output_result(point)
  puts point
end

main if __FILE__ == './bowling'
