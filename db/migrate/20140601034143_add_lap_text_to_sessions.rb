class AddLapTextToSessions < ActiveRecord::Migration
  def change
    add_column :sessions, :lap_text, :text
  end
end
