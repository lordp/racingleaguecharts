class AddPolePositionToResult < ActiveRecord::Migration
  def change
    add_column :results, :pole_position, :boolean
  end
end
