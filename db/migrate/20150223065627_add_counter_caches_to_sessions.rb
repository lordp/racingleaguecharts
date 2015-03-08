class AddCounterCachesToSessions < ActiveRecord::Migration
  def change
    add_column :sessions, :laps_count, :integer
    add_column :sessions, :screenshots_count, :integer
  end
end
