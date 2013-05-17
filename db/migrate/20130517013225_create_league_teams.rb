class CreateLeagueTeams < ActiveRecord::Migration
  def change
    create_table :league_teams do |t|
      t.integer :league_id
      t.integer :team_id
      t.integer :points

      t.timestamps
    end
  end
end
