class LeagueSeason < ActiveRecord::Base
  attr_accessible :league_id, :season_id

  belongs_to :league
  belongs_to :season
end
