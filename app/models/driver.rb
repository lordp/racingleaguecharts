class Driver < ActiveRecord::Base
  attr_accessible :ip, :name, :flair, :colour, :marker

  has_many :sessions

  has_one :driver_user
  has_one :user, :through => :driver_user

  validates_presence_of :name
  validates_uniqueness_of :name

  def claimed?
    if name.blank?
      'Unknown'
    else
      name
    end
  end

  def self.unclaimed?
    Driver.includes(:driver_user).where('driver_users.user_id is null')
  end

end
