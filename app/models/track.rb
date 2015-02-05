class Track < ActiveRecord::Base
  has_many :sessions
  has_many :races

  validates :name, :presence => true, :allow_blank => true, :uniqueness => true
  validates :length, :numericality => true

  def name
    db_name = read_attribute(:name)
    if db_name.blank?
      "Unknown (length: #{self.length}m)"
    else
      db_name
    end
  end
end
