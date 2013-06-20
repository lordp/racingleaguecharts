class Driver < ActiveRecord::Base
  attr_accessible :name, :team_id, :country, :league_id

  belongs_to :team
  belongs_to :league
  has_many :results
  has_many :races, :through => :results

  before_save :update_points
  after_save :update_team_points

  delegate :name, :to => :team, :prefix => true
  delegate :name, :to => :league, :prefix => true, :allow_nil => true

  POINTS = [10, 8, 6, 5, 4, 3, 2, 1]

  def update_points
    self.points = self.results.where('position between 1 and 8').inject(0) do |sum, result|
      sum += POINTS[result.position - 1]
    end
  end

  def update_team_points
    self.team.update_points(self.league)
  end

end
