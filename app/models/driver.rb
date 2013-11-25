class Driver < ActiveRecord::Base
  attr_accessible :ip, :name

  has_many :laps
  has_many :sessions, :through => :laps, :uniq => true

  def claimed?
    if name.blank?
      'Unknown'
    else
      name
    end
  end

end
