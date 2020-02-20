class CreateAttendances < ActiveRecord::Migration[5.2]
  def change
    create_table :attendances do |t|
      t.string   :user_id,       null: false
      t.datetime :going_to_work, null: false
      t.datetime :leave_work

      t.timestamps
    end
  end
end
