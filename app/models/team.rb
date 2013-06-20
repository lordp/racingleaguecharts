class Team < ActiveRecord::Base
  attr_accessible :name, :flair, :country, :league_ids

  has_many :drivers
  has_many :results

  has_many :league_teams
  has_many :leagues, :through => :league_teams

  def points(league)
    league_teams.where(:league_id => league).first.points
  end
end
