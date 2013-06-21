class Result < ActiveRecord::Base
  attr_accessible :driver_id, :fastest_lap, :position, :race_id, :pole_position, :team_id

  belongs_to :race
  belongs_to :driver
  belongs_to :team

  before_save :update_points
  after_save :update_driver_points

  delegate :name, :to => :driver, :prefix => true
  delegate :name, :to => :race, :prefix => true
  delegate :name, :to => :team, :prefix => true, :allow_nil => true

  def describe_position
    case position
    when -1
      'Retired'
    when -2
      'Disqualified'
    else
      position.ordinalize
    end
  end

  private

    def update_points
      self.points = Driver::POINTS[self.position - 1] if (1..8).include?(self.position)
    end

    def update_driver_points
      self.driver.save
    end

end
