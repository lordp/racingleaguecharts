class Telemetry
  attr_accessor :filename, :client, :prev_lap, :time, :lap_time, :lap_distance,
    :distance, :x, :y, :z,
    :speed, :world_speed_x, :world_speed_y, :world_speed_z,
    :xr, :roll, :zr, :xd, :pitch, :zd,
    :suspension_position_rear_left,
    :suspension_position_rear_right,
    :suspension_position_front_left,
    :suspension_position_front_right,
    :suspension_velocity_rear_left,
    :suspension_velocity_rear_right,
    :suspension_velocity_front_left,
    :suspension_velocity_front_right,
    :wheel_speed_back_left, :wheel_speed_back_right,
    :wheel_speed_front_left, :wheel_speed_front_right,
    :throttle, :steer, :brake, :clutch, :gear,
    :lateral_acceleration,
    :longitudinal_acceleration,
    :lap, :engine_revs, :new_field1,
    :race_position,
    :kers_remaining, :kers_recharge, :drs_status,
    :difficulty, :assists, :fuel_remaining,
    :session_type, :new_field10, :sector,
    :time_sector1, :time_sector2,
    :brake_temperature_rear_left,
    :brake_temperature_rear_right,
    :brake_temperature_front_left,
    :brake_temperature_front_right,
    :new_field18, :new_field19, :new_field20, :new_field21,
    :completed_laps_in_race, :total_laps_in_race, :track_length, :previous_lap_time,
    :new_field_1301, :new_field_1302, :new_field_1303

  def initialize(client, data)
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
    @completed_laps_in_race, @total_laps_in_race, @track_length, @previous_lap_time,
    @new_field_1301, @new_field_1302, @new_field_1303 = data

    @client = client
    @filename = "#{client}-#{self.session_type_name}.csv"
  end

  def session_type_name
    case @session_type
      when 9.5
        'race'
      when 10
        'time-trial'
      when 11..170
        @session_type.to_s
      else
        'practice'
    end
  end

  def to_csv
    csv = []
    self.instance_variables.each do |var|
      csv << self.instance_variable_get(var)
    end
    csv.to_csv
  end

  def to_json
    hash = {}
    self.instance_variables.each do |var|
      hash[var.gsub(/@/, '')] = self.instance_variable_get(var)
    end
    hash.to_json
  end

  def save
    File.open(@filename, 'ab') do |f|
      f.write(self.to_csv)
    end

    self
  end

  def save_lap(ip, lap)
    d = Driver.find_or_create_by_ip(ip)
    l = Lap.find_or_create_by_driver_id_and_lap_number(d.id, lap[:lap] + 1)
    l.update({
      :sector_1 => lap[:s1],
      :sector_2 => lap[:s2],
      :sector_3 => lap[:plt] - lap[:s1] - lap[:s2],
      :total    => lap[:plt]
    }) unless lap[:s1].nil?
  end
end
