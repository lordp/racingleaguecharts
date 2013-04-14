class Driver < ActiveRecord::Base
  attr_accessible :name, :team_id

  belongs_to :team
  has_many :results
  has_many :races, :through => :results
  has_many :leagues, :through => :races, :uniq => true

  before_save :update_points

  delegate :name, :to => :team, :prefix => true

  POINTS = [10, 8, 6, 5, 4, 3, 2, 1]

  def league
    self.leagues.first
  end

  def update_points
    self.points = self.results.reject { |result| !(1..8).include?(result.position) }.inject(0) do |sum, result|
      sum += POINTS[result.position - 1]
    end
  end
end
