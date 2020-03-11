class CreatePositions < ActiveRecord::Migration[5.2]
  def change
    create_table :positions do |t|
      t.integer :authority
      t.references :user

      t.timestamps
    end
  end
end
