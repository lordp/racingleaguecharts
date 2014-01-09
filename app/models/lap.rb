class Lap < ActiveRecord::Base
  attr_accessible :driver_id, :lap_number, :race_id, :sector_1, :sector_2, :sector_3, :session_id, :total

  belongs_to :session
  belongs_to :race
  belongs_to :driver

  def self.convert_lap(lap)
    time = lap.match(/((\d):)?([\d\.]+)/)
    if time[2].nil?
      time[3].to_f
    else
      (time[2].to_i * 60) + time[3].to_f
    end
  end
end
