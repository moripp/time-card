class FixTimeController < ApplicationController
  # 勤怠編集に関するコントローラー

  before_action :move_to_Log_in
  before_action :check_authority_Stop_other_than_admin

  def index
    @users = User.all
    @month = Time.current.strftime("%-m").to_i
  end

  def edit # 勤怠編集画面へ
    year = year_params
    month = month_params
    user_id = user_id_params
    @attendances = Attendance.get_member_attendances(year, month, user_id)
    @user = User.find(user_id)
    @year = year
    @month = month
  end

  def update # 勤怠編集処理
    year = params.require(:year).to_i
    month = params.require(:month).to_i
    user = User.find(params.require(:user_id).to_i)
    my_id = current_user.id
    Attendance.create_new_attendances(new_Attendances_params, year, month, user, my_id) if new_Attendances_params # 勤怠レコードを新しく作る
    Attendance.update_edit_attendances(params, year, month, user, my_id) if edit_Attendances_params # すでに存在する勤怠レコードを修正する

    @attendances = Attendance.get_member_attendances(year, month, user.id)
    @user = user
    @year = year
    @month = month
    render :edit
  end

  private
  def year_params
    params.require(:date)[:year].to_i
  end

  def month_params
    params.require(:date)[:month].to_i
  end

  def user_id_params
    params.require(:user)[:name_select].to_i
  end

  def new_Attendances_params
    if params[:newAttendances]
      params.require(:newAttendances)
    else
      return false
    end
  end

  def edit_Attendances_params
    if params[:editAttendances]
      params.require(:editAttendances)
    else
      return false
    end
  end
end
