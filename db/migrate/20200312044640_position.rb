class Position < ActiveRecord::Migration[5.2]
  def change
    drop_table :positions
  end
end
