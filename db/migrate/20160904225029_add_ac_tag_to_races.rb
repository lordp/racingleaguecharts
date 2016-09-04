class AddAcTagToRaces < ActiveRecord::Migration
  def change
    add_column :races, :assetto_corsa, :boolean
  end
end
