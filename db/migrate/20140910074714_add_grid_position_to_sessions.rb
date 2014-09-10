class AddGridPositionToSessions < ActiveRecord::Migration
  def change
    add_column :sessions, :grid_position, :integer
  end
end
