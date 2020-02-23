class CreateStatuses < ActiveRecord::Migration[5.2]
  def change
    create_table :statuses do |t|
      t.integer :state
      t.references :user

      t.timestamps
    end
  end
end
