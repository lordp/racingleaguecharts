class DriverUser < ActiveRecord::Base
  attr_accessible :driver_id, :user_id

  belongs_to :user
  belongs_to :driver
end
