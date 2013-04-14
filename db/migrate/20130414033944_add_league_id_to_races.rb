class AddLeagueIdToRaces < ActiveRecord::Migration
  def change
    add_column :races, :league_id, :integer
  end
end
