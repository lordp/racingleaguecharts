class CreateResults < ActiveRecord::Migration
  def change
    create_table :results do |t|
      t.integer :race_id
      t.integer :driver_id
      t.integer :position
      t.boolean :fastest_lap

      t.timestamps
    end
  end
end
