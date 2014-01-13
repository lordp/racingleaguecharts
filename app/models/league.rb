class League < ActiveRecord::Base
  attr_accessible :name, :season_ids

  belongs_to :super_league
  has_many :seasons
end
