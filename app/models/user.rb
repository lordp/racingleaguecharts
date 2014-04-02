class User < ActiveRecord::Base
  has_secure_password
  attr_accessible :email, :password, :password_confirmation, :driver_ids
  validates_uniqueness_of :email

  has_many :driver_users
  has_many :drivers, :through => :driver_users

  def has_claimed?(driver)
    self.drivers.include?(driver)
  end
end
