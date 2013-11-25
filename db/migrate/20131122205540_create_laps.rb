class CreateLaps < ActiveRecord::Migration
  def change
    create_table :laps do |t|
      t.integer :session_id
      t.integer :race_id
      t.integer :driver_id
      t.integer :lap_number
      t.float :sector_1
      t.float :sector_2
      t.float :sector_3
      t.float :total

      t.timestamps
    end
  end
end
