class League < ActiveRecord::Base
  attr_accessible :name

  has_many :races
  has_many :drivers, :through => :races, :uniq => true
  has_many :results, :through => :races

  has_many :league_teams
  has_many :teams, :through => :league_teams
end
