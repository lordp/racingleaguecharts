class AddFlairToDrivers < ActiveRecord::Migration
  def change
    add_column :drivers, :flair, :string
  end
end
