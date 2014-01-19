class Track < ActiveRecord::Base
  attr_accessible :name, :length

  has_many :sessions
  has_many :races
end
