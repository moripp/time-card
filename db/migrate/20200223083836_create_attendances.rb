class CreateAttendances < ActiveRecord::Migration[5.2]
  def change
    create_table :attendances do |t|
      t.datetime :going_to_work
      t.datetime :leave_work
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
