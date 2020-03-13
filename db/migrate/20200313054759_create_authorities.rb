class CreateAuthorities < ActiveRecord::Migration[5.2]
  def change
    create_table :authorities do |t|
      t.integer :auth
      t.references :user

      t.timestamps
    end
  end
end
