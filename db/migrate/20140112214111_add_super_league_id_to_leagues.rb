class AddSuperLeagueIdToLeagues < ActiveRecord::Migration
  def change
    add_column :leagues, :super_league_id, :integer
  end
end
