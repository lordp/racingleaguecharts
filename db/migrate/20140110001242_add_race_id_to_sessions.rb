class AddRaceIdToSessions < ActiveRecord::Migration
  def change
    change_table :sessions do |t|
      t.integer :race_id
    end
  end
end
