class Team < ActiveRecord::Base
  attr_accessible :name

  has_many :drivers
  has_many :results

  def points(league)
    League.find(league).results.where(:team_id => self.id).sum(:points)
  end
end
