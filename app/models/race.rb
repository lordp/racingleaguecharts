class Race < ActiveRecord::Base
  attr_accessible :name, :track_length

  has_many :laps
end
