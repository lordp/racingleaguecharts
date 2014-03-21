class AddThingToRaces < ActiveRecord::Migration
  def change
    add_column :races, :thing, :string
  end
end
