class AddFastestLapToSessions < ActiveRecord::Migration
  def change
    add_column :sessions, :fastest_lap_id, :integer
  end
end
