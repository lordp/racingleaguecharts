class League < ActiveRecord::Base
  belongs_to :super_league
  has_many :seasons

  validates :name, :presence => true
  validates :super_league_id, :numericality => true

  def full_name
    "#{super_league.name} - #{name}"
  end

  def filter_name
    "#{self.try(:super_league).try(:name).try(:parameterize)}-#{self.try(:name).try(:parameterize)}"
  end

end
