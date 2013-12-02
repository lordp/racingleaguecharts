class Session < ActiveRecord::Base
  attr_accessible :token, :type

  has_many :laps
  has_many :races, :through => :laps, :uniq => true
  has_many :drivers, :through => :laps, :uniq => true

  def average_lap
    laps.average(:total)
  end
end
