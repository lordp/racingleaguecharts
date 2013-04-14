class AddPointsToResults < ActiveRecord::Migration
  def change
    add_column :results, :points, :integer
  end
end
