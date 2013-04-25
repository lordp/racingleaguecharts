class Team < ActiveRecord::Base
  attr_accessible :name, :flair, :country

  has_many :drivers
  has_many :results

  def points(league)
    League.find(league).results.where(:team_id => self.id).sum(:points)
  end
end
