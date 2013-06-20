class AddLeagueToDrivers < ActiveRecord::Migration
  def change
    add_column(:drivers, :league_id, :integer)

    leagues = {
      1 => [6, 5, 3, 12, 8, 15, 7, 11, 18, 10, 16, 2, 14, 1, 4, 9, 13, 17],
      2 => [36, 21, 31, 38, 22, 23, 34, 29, 26, 28, 24, 42, 33, 32, 39, 19, 37, 30, 40, 20, 27, 41, 35, 25],
      3 => [46, 48, 44, 43, 45, 47, 49],
    }

    leagues.each do |league_id, players|
      Driver.find(players).each do |player|
        player.update_attribute(:league_id, league_id)
      end
    end
  end
end
