class CreateCorrectionRecords < ActiveRecord::Migration[5.2]
  def change
    create_table :correction_records do |t|
      t.references :user
      t.references :attendance
      t.integer :type
      t.datetime :before_going
      t.datetime :before_leave
      t.datetime :after_going
      t.datetime :after_leave

      t.timestamps
    end
  end
end
