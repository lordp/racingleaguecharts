class AddFieldsToLaps < ActiveRecord::Migration
  def change
    add_column :laps, :speed, :decimal
    add_column :laps, :position, :integer
    add_column :laps, :fuel, :decimal
  end
end
