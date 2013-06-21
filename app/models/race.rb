class Race < ActiveRecord::Base
  attr_accessible :name, :short_name, :league_id, :flag, :start_date

  has_many :results
  belongs_to :league

  has_many :drivers, :through => :results

  delegate :name, :to => :league, :prefix => true

  def name_and_league
    "#{self.league_name} - #{self.name}"
  end

  def winner
    Result.where(:race_id => self.id).where(:position => 1).first
  end

  def fastest_lap
    Result.where(:race_id => self.id).where(:fastest_lap => true).first
  end

end
