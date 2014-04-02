class CreateDriverUsers < ActiveRecord::Migration
  def change
    create_table :driver_users do |t|
      t.integer :driver_id
      t.integer :user_id

      t.timestamps
    end
  end
end
