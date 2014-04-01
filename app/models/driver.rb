class Driver < ActiveRecord::Base
  attr_accessible :ip, :name, :flair, :colour, :marker

  has_many :sessions

  def claimed?
    if name.blank?
      'Unknown'
    else
      name
    end
  end

end
