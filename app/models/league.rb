class League < ActiveRecord::Base
  attr_accessible :name, :season_ids

  has_many :league_seasons
  has_many :seasons, :through => :league_seasons
end
