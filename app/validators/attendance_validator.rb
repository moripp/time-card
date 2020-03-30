class AttendanceValidator < ActiveModel::Validator

  # 出勤時間が退勤時間より遅い場合、DBに保存しない
  def validate(record)
    going_to_work = record[:going_to_work]
    leave_work = record[:leave_work]
    unless leave_work.nil?
      if going_to_work >= leave_work
        record.errors[:leave_work] << (options[:message] || '無効な値です')
      end
    end
  end
end