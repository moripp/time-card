module ApplicationHelper

  # 日付と曜日を表示するメソッド
  def set_date(time)
    wd = ["日", "月", "火", "水", "木", "金", "土"]
    time.strftime("%-d(#{wd[time.wday]})")
  end

  # 日付だけ取り出すメソッド
  def set_day(time)
    time.strftime("%-d")
  end

  # 時間だけ表示するメソッド
  def set_time(time)
    time.strftime("%H:%M")
  end

  # 勤務時間を表示するメソッド（出勤時間と退勤時間の秒を切り捨ててから計算している）
  def set_working_hours(time1, time2)
    time1 = time1 - time1.strftime("%S").to_i
    time2 = time2 - time2.strftime("%S").to_i
    total = time2 - time1
    Time.at(total).utc.strftime("%R")
  end

  # n年前を取得
  def ago_year(n)
    Time.current.ago(n.years).year
  end
end