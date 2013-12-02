require 'csv'
#require 'chronic_duration'
require 'std_dev'

class Telemetry
  attr_accessor :time, :lap_time, :lap_distance, :distance, :x, :y, :z, :speed, :world_speed_x, :world_speed_y, :world_speed_z,
                :xr, :roll, :zr, :xd, :pitch, :zd, :suspension_position_rear_left, :suspension_position_rear_right,
                :suspension_position_front_left, :suspension_position_front_right, :suspension_velocity_rear_left,
                :suspension_velocity_rear_right, :suspension_velocity_front_left, :suspension_velocity_front_right,
                :wheel_speed_back_left, :wheel_speed_back_right, :wheel_speed_front_left, :wheel_speed_front_right,
                :throttle, :steer, :brake, :clutch, :gear, :lateral_acceleration, :longitudinal_acceleration,
                :lap, :engine_revs, :new_field1, :race_position, :kers_remaining, :kers_recharge, :drs_status,
                :difficulty, :assists, :fuel_remaining, :session_type, :new_field10, :sector, :time_sector1, :time_sector2,
                :brake_temperature_rear_left, :brake_temperature_rear_right, :brake_temperature_front_left,
                :brake_temperature_front_right, :new_field18, :new_field19, :new_field20, :new_field21,
                :completed_laps_in_race, :total_laps_in_race, :track_length, :previous_lap_time


  def initialize(data)
    @time, @lap_time, @lap_distance,
    @distance, @x, @y, @z,
    @speed, @world_speed_x, @world_speed_y, @world_speed_z,
    @xr, @roll, @zr, @xd, @pitch, @zd,
    @suspension_position_rear_left,
    @suspension_position_rear_right,
    @suspension_position_front_left,
    @suspension_position_front_right,
    @suspension_velocity_rear_left,
    @suspension_velocity_rear_right,
    @suspension_velocity_front_left,
    @suspension_velocity_front_right,
    @wheel_speed_back_left, @wheel_speed_back_right,
    @wheel_speed_front_left, @wheel_speed_front_right,
    @throttle, @steer, @brake, @clutch, @gear,
    @lateral_acceleration,
    @longitudinal_acceleration,
    @lap, @engine_revs, @new_field1,
    @race_position,
    @kers_remaining, @kers_recharge, @drs_status,
    @difficulty, @assists, @fuel_remaining,
    @session_type, @new_field10, @sector,
    @time_sector1, @time_sector2,
    @brake_temperature_rear_left,
    @brake_temperature_rear_right,
    @brake_temperature_front_left,
    @brake_temperature_front_right,
    @new_field18, @new_field19, @new_field20, @new_field21,
    @completed_laps_in_race, @total_laps_in_race, @track_length, @previous_lap_time = data.map(&:to_f)
  end

  def to_json
    hash = {}
    self.instance_variables.each do |var|
      hash[var] = self.instance_variable_get(var)
    end
    hash.to_json
  end

  def save(fd)
    fd.write(self.to_json)
  end
end

namespace :scan do

  desc "Scan laps"
  task :laps => :environment do
    prev_lap = 0
    time_sector_1 = time_sector_2 = 0
    laps = []
    sector_1 = []
    sector_2 = []
    sector_3 = []

    file = ENV['FILENAME'] || exit
    CSV.foreach(file) do |row|
      next if row.empty?

      t = Telemetry.new(row)
      next if t.lap_time == 0# || t.session_type == 170

      if t.time_sector1 > 0
        time_sector_1 = t.time_sector1
      end

      if t.time_sector2 > 0
        time_sector_2 = t.time_sector2
      end

      if t.completed_laps_in_race > prev_lap && t.completed_laps_in_race > 0
        laps << t.previous_lap_time.round(3)
        time_sector_3 = t.previous_lap_time - (time_sector_1 + time_sector_2)
        sector_1 << time_sector_1
        sector_2 << time_sector_2
        sector_3 << time_sector_3
        #puts "[#{ChronicDuration.output(t.time.round(3), :format => :chrono)}] Lap #{t.completed_laps_in_race.to_i}: S1: #{time_sector_1.round(3)}, S2: #{time_sector_2.round(3)}, S3: #{time_sector_3.round(3)}, T: #{ChronicDuration.output(t.previous_lap_time.round(3), :format => :chrono, :keep_zeros => true)}"
        prev_lap = t.completed_laps_in_race
      end
    end

    puts laps.standard_deviation
    #puts sector_1.inspect
    puts sector_1.standard_deviation
    #puts sector_2.inspect
    puts sector_2.standard_deviation
    #puts sector_3.inspect
    puts sector_3.standard_deviation
  end
end
