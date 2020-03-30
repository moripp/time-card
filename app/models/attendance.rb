class Attendance < ApplicationRecord
  # association
  belongs_to :user
  has_many :correction_records

  # validations
  validates :going_to_work, presence: true # 出勤時間は必須
  validates_with AttendanceValidator # 出勤時間 < 退勤時間の場合保存しない

  # methods
  # 勤怠情報のデータをまとめた配列を作成する（勤怠データを格納。データが無い日は休日のデータを作成し配列に格納。）
  def self.get_mytimes(year, month, id)
    # 前提のデータと値を準備
    search_date = "#{year}-#{month}-1"
    end_of_month = search_date.in_time_zone.end_of_month.strftime("%-d").to_i # 該当月の月末の日付を格納
    attendances = Attendance.where( user_id: id,
                                    going_to_work: search_date.in_time_zone.all_month) # 出勤時間が該当月
                            .where.not(leave_work: nil) # 退勤時間がnilでない
                            .order(going_to_work: "ASC")
    my_attendances = []
    length = attendances.length
    day = 1
    array_num = 0

    # 勤怠情報のデータをまとめた配列を作成する処理
    while day <= end_of_month do
      while array_num < length do
        if day == attendances[array_num].going_to_work.strftime("%-d").to_i
          my_attendances << attendances[array_num]
          # 同じ日に複数の勤怠が存在する可能性を考慮してunlessの条件追加
          unless array_num != length - 1 && attendances[array_num].going_to_work.strftime("%-d").to_i == attendances[array_num + 1].going_to_work.strftime("%-d").to_i
            day = day + 1
          end
          array_num = array_num + 1
        else
          my_attendances << ["holiday", "#{year}-#{month}-#{day}".in_time_zone]
          day = day + 1
        end
      end
      unless day > end_of_month
        my_attendances << ["holiday", "#{year}-#{month}-#{day}".in_time_zone]
        day = day + 1
      end
    end

    return my_attendances
  end

  # 勤怠情報のデータをまとめた配列を作成する（上のメソッドと似ているが条件が少し違う）
  def self.get_member_attendances(year, month, id)
    search_date = "#{year}-#{month}-1"
    end_of_month = search_date.in_time_zone.end_of_month.strftime("%-d").to_i # 該当月の月末の日付を格納
    attendances = Attendance.where( user_id: id,
                                    going_to_work: search_date.in_time_zone.all_month) # 出勤時間が該当月
                            .order(going_to_work: "ASC")
    my_attendances = []
    length = attendances.length
    day = 1
    array_num = 0
    user = User.find(id)

    while day <= end_of_month do
      while array_num < length do
        if day == attendances[array_num].going_to_work.strftime("%-d").to_i
          my_attendances << attendances[array_num]
          unless array_num != length - 1 && attendances[array_num].going_to_work.strftime("%-d").to_i == attendances[array_num + 1].going_to_work.strftime("%-d").to_i
            day = day + 1
          end
          array_num = array_num + 1
        else
          new_attendance = user.attendances.new
          my_attendances << ["holiday", "#{year}-#{month}-#{day}".in_time_zone, new_attendance]
          day = day + 1
        end
      end
      unless day > end_of_month
        new_attendance = user.attendances.new
        my_attendances << ["holiday", "#{year}-#{month}-#{day}".in_time_zone, new_attendance]
        day = day + 1
      end
    end

    return my_attendances
  end

  # 勤怠レコードを一括で新しく作る
  def self.create_new_attendances(new_array, year, month, user, my_id)
    new_array.each do |attendance|
      if !attendance[:going_to_work].empty? && !attendance[:leave_work].empty? 
        going = "#{year}-#{month}-#{attendance[:date]} #{attendance[:going_to_work]}".in_time_zone
        leave = "#{year}-#{month}-#{attendance[:date]} #{attendance[:leave_work]}".in_time_zone
        ActiveRecord::Base.transaction do
          new_attendance = user.attendances.new(going_to_work: going ,leave_work: leave)
          new_attendance.save!
          CorrectionRecord.correction_new(going, leave, new_attendance, my_id)
        end
      else
        # 両方空の場合は何もしない
        # どちらか片方空の可能性があるがjsで弾く（仮にjsをスルーしたらサーバーでは何もしない）
      end
    end
  end

  # 勤怠レコードを一括で編集する
  def self.update_edit_attendances(params, year, month, user, my_id)
    search_date = "#{year}-#{month}-1"
    edit_array = params.require(:editAttendances).keys.sort.map { |index| params.require(:editAttendances)[index] }
    raw_data = Attendance.where(user_id: user.id, going_to_work: search_date.in_time_zone.all_month)

    edit_array.each do |attendance|
      id = attendance[:id].to_i
      datum = raw_data.find{|n| n.id == id}
      if attendance[:going_to_work].empty? && attendance[:leave_work].empty?
        ActiveRecord::Base.transaction do
          CorrectionRecord.correction_delete(datum, my_id)
          datum.destroy!
        end
      elsif attendance[:going_to_work].empty? || attendance[:leave_work].empty?
        # どちらか片方空の可能性があるがjsで弾く（仮にjsをスルーしたらサーバーでは何もしない）
      else
        new_going = datum.going_to_work.strftime("%Y-%m-%d #{attendance[:going_to_work]}").in_time_zone
        new_leave = datum.going_to_work.strftime("%Y-%m-%d #{attendance[:leave_work]}").in_time_zone
        if datum.leave_work.nil?
          datum_going = datum.going_to_work.strftime("%H:%M")
          datum_leave = ""
        else
          datum_going = datum.going_to_work.strftime("%H:%M")
          datum_leave = datum.leave_work.strftime("%H:%M")
        end
        unless attendance[:going_to_work] == datum_going && attendance[:leave_work] == datum_leave
          ActiveRecord::Base.transaction do
            CorrectionRecord.correction_edit(datum, new_going, new_leave, my_id)
            datum.update(going_to_work: new_going, leave_work: new_leave)
          end
        end
      end
    end
  end

end
