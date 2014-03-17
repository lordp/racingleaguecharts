class AddIsDryToRaces < ActiveRecord::Migration
  def change
    add_column :races, :is_dry, :boolean
  end
end
