## オプション -y, -mから年と月の値を取得
require 'optparse'
require 'date'

opt = OptionParser.new
opt.on('-y')
opt.on('-m')

year_month_output = opt.parse!(ARGV)
year = year_month_output[0].to_i #=>年
month = year_month_output[1].to_i #=>月

### 引数指定しない場合 => 今年・今月の結果を返す
argv_decision = ARGV.empty?
today = Date.today

if argv_decision == true
  year = today.year
  month = today.month
end

## 月末日を求めて配列作成
month_last_date = Date.new(year, month, -1).day
date_array = (1..month_last_date).to_a
### カレンダー表示の関係で、数字前に半角スペースを入れて調整
date_array[0..8] = [" 1"," 2", " 3", " 4", " 5" ," 6", " 7", " 8", " 9"]

## 月初日から曜日を求めて、曜日と日付を対応させた配列を作成する
month_first_day = Date.new(year, month, 1)
day_of_the_week_num = month_first_day.wday # 追加する空白数に該当
display_days_array = []

### 空文字の追加
if day_of_the_week_num == 0
  display_days_array = date_array
else
  day_of_the_week_num.times do
    display_days_array = date_array.unshift("　")
  end
end

## コマンドラインへの出力
  puts ("　　  #{month}月 #{year}    　　")
  puts ("日 月 火 水 木 金 土")
  display_days_array.each_slice(7) {|n| puts n.join(" ")}# 区切り文字半角
