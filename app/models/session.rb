class Session < ActiveRecord::Base
  attr_accessible :token, :session_type, :driver_id, :track_id, :race_id, :winner, :screenshot_ids, :lap_text, :grid_position

  has_many :laps
  has_many :screenshots

  belongs_to :track
  belongs_to :driver
  belongs_to :race

  SESSION_TYPE_TIME_TRIAL = 10.0
  SESSION_TYPE_QUALIFYING = 170.0
  SESSION_TYPE_ONE_SHOT   = 114.999992371

  LINE_REGEX = /([\d]+) ([\d:\.]+) ([\d:\.]+) ([\d:\.]+) ([\d:\.]+)( ([\d\.]+) ([\d\.]+))?$/

  validate :laps_are_in_order, :on => :update, :unless => lambda { |s| s.lap_text.blank? }
  after_save :create_laps, :unless => lambda { |s| s.lap_text.blank? }

  def create_laps
    self.lap_text.split(/\r\n/).each do |line|
      match = line.match(LINE_REGEX)
      self.laps.find_or_create_by_lap_number(match[1].to_i - 1) do |lap|
        lap.total = Lap.convert_lap(match[2])
        lap.sector_1 = Lap.convert_lap(match[3])
        lap.sector_2 = Lap.convert_lap(match[4])
        lap.sector_3 = Lap.convert_lap(match[5])
        lap.speed = match[7]
        lap.fuel = match[8]
      end
    end
  end

  def laps_are_in_order
    input = lap_text.scan(LINE_REGEX).map { |l| l[1].to_i }
    expected = (input.first..input.last).to_a
    if input != expected
      errors[:base] << "The lap numbers are out of order or incorrect"
    end
  end

  def name
    "#{driver.try(:name)} on #{track.try(:name)} at #{created_at}"
  end

  def nice_session_type
    case session_type
      when SESSION_TYPE_TIME_TRIAL
        'Time Trial'
      when SESSION_TYPE_QUALIFYING
        'Qualifying'
      when SESSION_TYPE_ONE_SHOT
        'One Shot Qualifying'
      when nil
        'Unknown'
      else
        'Race'
    end
  end

  def session_time
    case session_type
      when SESSION_TYPE_QUALIFYING, SESSION_TYPE_TIME_TRIAL, SESSION_TYPE_ONE_SHOT
        fastest_lap.try(:total)
      else
        total_time
    end
  end

  def average_lap
    laps.size > 0 ? laps.average(:total).round(3) : 0
  end

  def fastest_lap
    laps.order(:total).first
  end

  def fuel_remaining
    laps.order(:lap_number).last.fuel.round(3)
  end

  def top_speed
    laps.order(:speed).last
  end

  def total_time
    laps.sum(:total)
  end

  def average_sector(sector)
    laps.average("sector_#{sector}")
  end

  def has_sectors?
    laps.collect(&:sector_1).compact.count > 0
  end

  def has_speed?
    laps.collect(&:speed).compact.count > 0
  end

  def has_fuel?
    laps.collect(&:fuel).compact.count > 0
  end

  def has_position?
    laps.collect(&:position).compact.count > 0
  end

  def set_info(ip, length)
    driver = Driver.find_or_create_by_ip(ip)
    track = Track.find_or_create_by_length(length)

    self.update_attributes({ :ip => ip, :driver_id => driver, :track_id => track })
  end

  def set_sector_time(sector, time, lap)
    @lap = Lap.find_or_initialize_by_driver_id_and_race_id_and_lap_number_and_session_id(@driver.id, @race.id, lap, id) if @lap.nil?
    @lap.send("sector_#{sector}=", time)

    @lap.save
  end

  def set_lap_time(total)
    @lap.total = total
    @lap.sector_3 = (total - @lap.sector_2 - @lap.sector_1) if @lap.sector_2 && @lap.sector_1

    @lap.save
    @lap = nil
  end

  def self.generate_token
    Time.now.to_i.to_s(36)
  end

  def self.register(params)
    driver = Driver.name_and_token(params[:driver], params[:token])
    track = Track.find_or_create_by_length(params[:track].to_f)
    race = Race.find(params[:race].to_i) if params[:race] && ![SESSION_TYPE_ONE_SHOT, SESSION_TYPE_QUALIFYING].include?(params[:type].to_f)
    race ||= nil
    Session.new(:driver_id => driver.try(:id), :track_id => track.try(:id), :race_id => race.try(:id), :session_type => params[:type])
  end

end
