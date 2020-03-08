class FixTimeController < ApplicationController
  # 勤怠編集に関するコントローラー

  before_action :move_to_Log_in

  def index # ユーザーと年月選択画面へ
    @users = User.all
    @month = Time.current.strftime("%-m").to_i
  end

  def edit # 勤怠編集画面へ
    # ①前提のデータや値を準備
    @user = User.find(user_id_params)
    @year = year_params
    @month = month_params
    search_date = "#{@year}-#{@month}-1"
    end_of_month = search_date.in_time_zone.end_of_month.strftime("%-d").to_i
    attendances = Attendance.where(user_id: @user.id, going_to_work: search_date.in_time_zone.all_month).order(going_to_work: "ASC")
    @attendances = []
    day = 1
    array_num = 0
    length = attendances.length

    # ②@attendancesの加工処理（最終的にビューに渡すメインデータ）
    while day <= end_of_month do
      while array_num < length do
        if day == set_day(attendances, array_num)
          @attendances << attendances[array_num]
          unless array_num != length - 1 and set_day(attendances, array_num) == set_day(attendances, array_num + 1)
            day = day + 1
          end
          array_num = array_num + 1
        else
          new_attendance = @user.attendances.new
          @attendances << ["holiday", "#{@year}-#{@month}-#{day}".in_time_zone, new_attendance]
          day = day + 1
        end
      end
      unless day > end_of_month
        new_attendance = @user.attendances.new
        @attendances << ["holiday", "#{@year}-#{@month}-#{day}".in_time_zone, new_attendance]
        day = day + 1
      end
    end
  end

  def update
    @year = 2020
    @month = 2
    @user = User.find(7)

    search_date = "#{@year}-#{@month}-1"
    
    new_array = params.require(:newAttendances)
    edit_array = params.require(:editAttendances).keys.sort.map { |index| params.require(:editAttendances)[index] }

    raw_data = Attendance.where( user_id: @user.id,going_to_work: search_date.in_time_zone.all_month)


    ActiveRecord::Base.transaction do
      new_array.each do |attendance|
        unless attendance[:going_to_work].empty? || attendance[:going_to_work].empty? 
          going = "#{@year}-#{@month}-#{attendance[:date]} #{attendance[:going_to_work]}".in_time_zone
          leave = "#{@year}-#{@month}-#{attendance[:date]} #{attendance[:leave_work]}".in_time_zone
          new_attendance = @user.attendances.new(going_to_work: going ,leave_work: leave)
          new_attendance.save!
        end
      end

      edit_array.each do |attendance|
        id = attendance[:id].to_i
        datum = raw_data.find{|n| n.id == id}

        if attendance[:going_to_work].empty? && attendance[:leave_work].empty?
          datum.destroy!
        elsif attendance[:going_to_work].empty? || attendance[:leave_work].empty?
          0/0
        else
          if datum.leave_work.nil?
            datum_going = datum.going_to_work.strftime("%H:%M")
            datum_leave = ""
            unless attendance[:going_to_work] == datum_going && attendance[:leave_work] == datum_leave
              datum.update!(going_to_work: datum.going_to_work.strftime("%Y-%m-%d #{attendance[:going_to_work]}").in_time_zone, leave_work: datum.going_to_work.strftime("%Y-%m-%d #{attendance[:leave_work]}").in_time_zone)
            end
          else
            datum_going = datum.going_to_work.strftime("%H:%M")
            datum_leave = datum.leave_work.strftime("%H:%M")
            unless attendance[:going_to_work] == datum_going && attendance[:leave_work] == datum_leave
              datum.update!(going_to_work: datum.going_to_work.strftime("%Y-%m-%d #{attendance[:going_to_work]}").in_time_zone, leave_work: datum.leave_work.strftime("%Y-%m-%d #{attendance[:leave_work]}").in_time_zone)
            end
          end
        end
      end
    end
      redirect_to action: 'edit'
    rescue
      redirect_to action: 'edit'
  end

  private
  def user_id_params
    params.require(:user)[:name_select].to_i
  end

  def year_params
    params.require(:date)[:year].to_i
  end

  def month_params
    params.require(:date)[:month].to_i
  end

  def set_day(array, num)
    array[num].going_to_work.strftime("%-d").to_i
  end

end
