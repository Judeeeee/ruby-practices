
#!以下の場合も考慮する。
#! 10フレーム目は1投目がストライクもしくは2投目がスペアだった場合、3投目が投げられる。

def main
  input = ARGV[0]
  convert_input(input)
  #frames = convert_input(input)
  #point = calculate_score(frames)
  #output_result(point)
end

def convert_input(input)
  shots = []
  frames = []
  scores = input.split(',')


  scores.each do |s|
    if s == 'X' #ストライクの場合を考慮
      shots << 10
      shots << 0
    else
      shots << s.to_i
    end
  end
  ##フレームごとに分割する
  shots.each_slice(2) do |n|
    frames << n
  end

  #最後の10投目で、スペアの場合、最後の配列と結合した配列を返す。
  if frames[9][0] + frames[9][1] == 10
    tmp = (frames[9] + frames[10]).delete_if{|x| x == 0}
    frames = frames[0..-3]
    frames = frames << tmp
  end

  #最後の10投目で、ストライクの場合。
  if frames[9][0] == 10 && frames[10]
    tmp = (frames[9] + frames[10]).delete_if{|x| x == 0}
    frames = frames[0..-3]
    frames = frames << tmp
  end
  p frames
  return frames
end

def calculate_score(flames)
  point = 0
  frag = false
  strike_flag = false
  flames.each do |flame|
    frame_score = flame.sum
    point += frame_score

    if strike_flag == true
      point += flame[0] + flame[1]
      strike_flag = false
    end

    #前のフレームがスペアの場合、この回の1投目を加算する。
    if frag == true
      point += flame[0]
      frag = false
    end

    #フレームがスペアorストライクの場合、fragを立てる
    if frame_score == 10 || flame[0] == 10
      frag = true
    end

    #ストライクの場合
    if flame[0] == 10
      strike_flag = true
    end
  end
  return point
end

# #スコア合計を標準出力
def output_result(point)
  puts point
end

if __FILE__== $0
  main
end
