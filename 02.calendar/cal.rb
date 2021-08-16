## オプション -y, -mから年と月の値を取得
require 'optparse'
require 'date'

opt = OptionParser.new
opt.on('-y')
opt.on('-m')


### 引数指定しない場合 => 今年・今月の結果を返す
year_month_input = opt.parse!(ARGV)
year = year_month_input[0].to_i
month = year_month_input[1].to_i
today = Date.today

if ARGV.empty?
  year = today.year
  month = today.month
end

## 月末日を求めて配列作成
month_last_date = Date.new(year, month, -1).day
date_array = (1..month_last_date).to_a

### カレンダー表示の関係で、右寄せに調整
date_array = date_array.map { |n| n.to_s }
date_array = date_array.map { |n| n.rjust(2, " ") }

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


puts ("　　  #{month}月 #{year}    　　")
puts ("日 月 火 水 木 金 土")
display_days_array.each_slice(7) {|n| puts n.join(" ")}
