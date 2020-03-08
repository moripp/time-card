class MytimesController < ApplicationController
  # 自分の出勤確認に関するコントローラー

  # 使用条件
  before_action :move_to_Log_in # ログインしている

  def index 
    @year = Time.current.strftime("%Y").to_i # 現在の年
    @month = Time.current.strftime("%-m").to_i # 現在の月
    mytimes_function
    render :show
  end

  def show
    @year = params_year # ユーザーが設定した年
    @month = params_month # ユーザーが設定した月
    mytimes_function
  end

  private
  def params_year
    params.require(:date)[:year].to_i
  end

  def params_month
    params.require(:date)[:month].to_i
  end

  def mytimes_function # 勤怠情報のデータをまとめた配列を作成する（勤怠データを格納。データが無い日は休日のデータを作成し配列に格納。）
    # 前提のデータと値を準備
    search_date = "#{@year}-#{@month}-1"
    end_of_month = search_date.in_time_zone.end_of_month.strftime("%-d").to_i # 該当月の月末の日付を格納
    attendances = Attendance.where( user_id: current_user.id,
                                    going_to_work: search_date.in_time_zone.all_month) # 出勤時間が該当月
                            .where.not(leave_work: nil) # 退勤時間がnilでない
                            .order(going_to_work: "ASC")
    @attendances = []
    length = attendances.length
    day = 1
    array_num = 0

    # 勤怠情報のデータをまとめた配列を作成する処理
    while day <= end_of_month do
      while array_num < length do
        if day == set_day(attendances, array_num)
          @attendances << attendances[array_num]
          # 同じ日に複数の勤怠が存在する可能性を考慮してunlessの条件追加
          unless array_num != length - 1 && set_day(attendances, array_num) == set_day(attendances, array_num + 1)
            day = day + 1
          end
          array_num = array_num + 1
        else
          @attendances << ["holiday", "#{@year}-#{@month}-#{day}".in_time_zone]
          day = day + 1
        end
      end
      unless day > end_of_month
        @attendances << ["holiday", "#{@year}-#{@month}-#{day}".in_time_zone]
        day = day + 1
      end
    end
  end

  def set_day(array, num) # mytimes_functionの中で使われる
    array[num].going_to_work.strftime("%-d").to_i
  end
end