class Race < ActiveRecord::Base
  attr_accessible :name, :session_ids, :track_id, :season_id, :time_trial

  has_many :sessions
  belongs_to :track
  belongs_to :season

  def full_name
    nm = []
    nm << (self.season.nil? || self.season.league.nil? ? 'No league' : self.season.league.name)
    nm << (self.season.nil? ? 'No season' : self.season.name)
    nm << (self.name.nil? ? 'No name' : self.name)

    nm.join('/')
  end
end
