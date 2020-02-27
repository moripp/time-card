class TimesController < ApplicationController
  def index
    return nil if params[:keyword] == ""
    @users = User.where(['name LIKE ?', "%#{params[:keyword]}%"]).limit(10)

    respond_to do |format|
      format.html
      format.json
    end
  end

  def create
    @user = User.find(user_id_params)
    @status = @user.status
    state = @status.state
    time = Time.now # 現在時刻を生成
    if state == "going_to_work" # 出勤中の場合
      @attendance = Attendance.where(user_id: user_id_params, leave_work: nil)
                              .where.not(going_to_work: nil)
                              .order(created_at: :desc).limit(1)
      check = @attendance.length # checkは基本1にしかならない（仮に例外があった場合は0になる）
      @value = ActiveRecord::Base.transaction do
        check / check
        @attendance[0].update!(leave_work: time)
        @status.update!(state: "leave_work")
      end
    else # 退勤中の場合
      @attendance = @user.attendances.new(going_to_work: time)
      @value =ActiveRecord::Base.transaction do
        @attendance.save!
        @status.update!(state: "going_to_work")
      end
    end
  end

  private
  def user_id_params
    params.require("user_id")
  end
end