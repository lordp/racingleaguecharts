class AddWinnerTagToSessions < ActiveRecord::Migration
  def change
    add_column :sessions, :winner, :boolean
  end
end
