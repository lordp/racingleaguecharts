class AddSeasonIdToRaces < ActiveRecord::Migration
  def change
    add_column :races, :season_id, :integer
  end
end
