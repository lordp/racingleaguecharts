class Lap < ActiveRecord::Base
  attr_accessible :driver_id, :lap_number, :race_id, :sector_1, :sector_2, :sector_3, :session_id, :total

  belongs_to :session
  belongs_to :race
  belongs_to :driver
end
