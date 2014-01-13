class Season < ActiveRecord::Base
  attr_accessible :name, :league_ids

  belongs_to :league
  has_many :races
end
