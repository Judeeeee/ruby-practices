require 'optparse'
require 'date'

opt = OptionParser.new
opt.on('-y')
opt.on('-m')

year_month_input = opt.parse!(ARGV)
year = year_month_input[0].to_i
month = year_month_input[1].to_i
today = Date.today

if ARGV.empty?
  year = today.year
  month = today.month
end

month_last_date = Date.new(year, month, -1).day
date_array = (1..month_last_date).to_a

### カレンダー表示の関係で、日付けを右寄せに調整
date_array = date_array.map { |n| n.to_s }
date_array = date_array.map { |n| n.rjust(2, " ") }

## 曜日と日付を対応させるために、月初日から曜日を求める
month_first_day = Date.new(year, month, 1)
day_of_the_week_num = month_first_day.wday
display_days_array = []

## ifで0の条件分岐を設置しないと、`0.times do ~~`になってしまい何も出力されなくなってしまう
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
