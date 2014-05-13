class League < ActiveRecord::Base
  attr_accessible :name, :season_ids, :super_league_id

  belongs_to :super_league
  has_many :seasons

  validates_presence_of :super_league_id, :name

  def full_name
    "#{super_league.name} - #{name}"
  end

  def filter_name
    "#{self.try(:super_league).try(:name).try(:parameterize)}-#{self.try(:name).try(:parameterize)}"
  end

end
