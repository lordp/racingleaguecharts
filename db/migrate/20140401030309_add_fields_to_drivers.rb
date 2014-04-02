class AddFieldsToDrivers < ActiveRecord::Migration
  def change
    add_column :drivers, :colour, :string
    add_column :drivers, :marker, :string
  end
end
