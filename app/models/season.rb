class Season < ActiveRecord::Base
  attr_accessible :name, :league_ids

  has_many :league_seasons
  has_many :leagues, :through => :league_seasons
end
