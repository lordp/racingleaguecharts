class Season < ActiveRecord::Base
  attr_accessible :name, :league_id, :time_trial

  belongs_to :league
  has_many :races

  validates_presence_of :name, :league_id

  def full_name
    "#{league.name} - #{name}"
  end

  def leaderboard
    lb = {}
    self.races.each do |race|
      race.sessions.includes(:laps).order('laps.total').limit(10).each_with_index do |s, i|
        driver = Driver.find(s.driver_id)
        lb[driver] ||= 0
        lb[driver] += Race::POINTS[i]
      end
    end
    lb.sort_by { |k, v| v }.reverse
  end

end
