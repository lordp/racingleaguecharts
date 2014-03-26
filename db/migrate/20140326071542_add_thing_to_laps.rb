class AddThingToLaps < ActiveRecord::Migration
  def change
    add_column :laps, :thing, :string
  end
end
