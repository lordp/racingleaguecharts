class AddQualifyingLapToSession < ActiveRecord::Migration
  def change
    add_column :sessions, :qualifying_lap, :float
  end
end
