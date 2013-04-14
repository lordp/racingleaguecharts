class AddPointsToDrivers < ActiveRecord::Migration
  def change
    add_column :drivers, :points, :integer
  end
end
