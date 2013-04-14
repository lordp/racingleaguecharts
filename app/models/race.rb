class Race < ActiveRecord::Base
  attr_accessible :name, :short_name, :league_id

  has_one :result
  belongs_to :league

  has_many :drivers, :through => :result

  delegate :name, :to => :league, :prefix => true

  def name_and_league
    "#{self.league_name} - #{self.name}"
  end
end
