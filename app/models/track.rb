class Track < ActiveRecord::Base
  attr_accessible :name, :length

  has_many :sessions
  has_many :races

  validates_presence_of :name, :length
  validates_numericality_of :length
end
