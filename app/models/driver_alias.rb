class DriverAlias < ActiveRecord::Base
  attr_accessible :driver_id, :name

  belongs_to :driver
end
