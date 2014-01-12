class CreateLeagueSeasons < ActiveRecord::Migration
  def change
    create_table :league_seasons do |t|
      t.integer :league_id
      t.integer :season_id

      t.timestamps
    end
  end
end
