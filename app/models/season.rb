class Season < ActiveRecord::Base
  attr_accessible :name, :league_id, :time_trial

  belongs_to :league
  has_many :races

  def full_name
    "#{league.name} - #{name}"
  end
end
