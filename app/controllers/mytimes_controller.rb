class MytimesController < ApplicationController
  before_action :move_to_Log_in
  
  def show
    year = 2020
    month = 2
    search_date = "#{year}-#{month}-1"
    end_of_month = search_date.in_time_zone.end_of_month.strftime("%-d").to_i
    attendances = Attendance.where( user_id: current_user.id,
                                    going_to_work: search_date.in_time_zone.all_month) # 出勤時間が該当月
                            .where.not(leave_work: nil) # 退勤時間がnilでない
                            .order(going_to_work: "ASC")
    @attendances = []
    length = attendances.length
    day = 1
    array_num = 0

    while day <= end_of_month do
      while array_num < length do
        if day == set_day(attendances, array_num)
          unless array_num == length - 1
            while set_day(attendances, array_num) == set_day(attendances, array_num + 1) do
              @attendances << attendances[array_num]
              array_num = array_num + 1
            end
          end
          @attendances << attendances[array_num]
          array_num = array_num + 1
          day = day + 1
        else
          @attendances << ["holiday", "#{year}-#{month}-#{day}".in_time_zone]
          day = day + 1
        end
      end
      @attendances << ["holiday", "#{year}-#{month}-#{day}".in_time_zone]
      day = day + 1
    end
  end

  private
  def set_day(array, num)
    array[num].going_to_work.strftime("%-d").to_i
  end
end