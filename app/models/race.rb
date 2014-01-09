class Race < ActiveRecord::Base
  attr_accessible :name, :length

  has_many :laps
end
