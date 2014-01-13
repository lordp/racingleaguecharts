class SuperLeague < ActiveRecord::Base
  attr_accessible :name

  has_many :leagues
end
