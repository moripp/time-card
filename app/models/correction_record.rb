class CorrectionRecord < ApplicationRecord
  # association
  belongs_to :user
  belongs_to :attendance

  enum type: {delete_re: 0, new_re: 1, edit_re: 2}

  # methods
  # 新しい勤怠レコード作成履歴
  def self.correction_new(going, leave, new_attendance, my_id)
    correction = CorrectionRecord.new(user_id: my_id, attendance_id: new_attendance.id, after_going: going, after_leave: leave)
    correction.type = 1
    correction.save!
  end

  # 勤怠レコードの削除履歴
  def self.correction_delete(datum, my_id)
    correction = CorrectionRecord.new(user_id: my_id, attendance_id: datum.id, before_going: datum.going_to_work, before_leave: datum.leave_work)
    correction.type = 0
    correction.save!
  end

  #勤怠レコード編集履歴
  def self.correction_edit(datum, new_going, new_leave, my_id)
    if datum.leave_work.nil?
      correction = CorrectionRecord.new(user_id: my_id, attendance_id: datum.id, before_going: datum.going_to_work,                                 after_going: new_going, after_leave: new_leave)
    else
      correction = CorrectionRecord.new(user_id: my_id, attendance_id: datum.id, before_going: datum.going_to_work, before_leave: datum.leave_work, after_going: new_going, after_leave: new_leave)
    end
    correction.type = 2
    correction.save!
  end
end
