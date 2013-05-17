class LeagueTeam < ActiveRecord::Base
  attr_accessible :league_id, :points, :team_id

  belongs_to :league
  belongs_to :team
end
