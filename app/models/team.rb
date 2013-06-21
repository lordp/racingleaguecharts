class Team < ActiveRecord::Base
  attr_accessible :name, :flair, :country, :league_ids

  has_many :drivers
  has_many :results

  has_many :league_teams
  has_many :leagues, :through => :league_teams

  def points(league)
    league_teams.where(league_id: league).first.points
  end

  def update_points(league)
    points = league.races.inject(0) do |sum, race|
      sum += self.race_points(race)
    end
    league_teams.where(league_id: league).first.update_attribute(:points, points)
  rescue
    0
  end

  def race_points(race)
    race.results.where(team_id: self.id).sum(:points)
  end
end
