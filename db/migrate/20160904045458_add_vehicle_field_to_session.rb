class AddVehicleFieldToSession < ActiveRecord::Migration
  def change
    add_column :sessions, :vehicle, :string
  end
end
