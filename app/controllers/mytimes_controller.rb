class MytimesController < ApplicationController
  # 自分の出勤確認に関するコントローラー

  before_action :move_to_Log_in

  def index 
    year = Time.current.strftime("%Y").to_i # 現在の年
    month = Time.current.strftime("%-m").to_i # 現在の月
    user_id = current_user.id
    @attendances = Attendance.get_mytimes(year, month, user_id)
    @year = year
    @month = month
    render :show
  end

  def show
    year = params_year # ユーザーが設定した年
    month = params_month # ユーザーが設定した月
    user_id = current_user.id
    @attendances = Attendance.get_mytimes(year, month, user_id)
    @year = year
    @month = month
  end

  private
  def params_year
    params.require(:date)[:year].to_i
  end

  def params_month
    params.require(:date)[:month].to_i
  end
end