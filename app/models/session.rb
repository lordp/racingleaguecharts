class Session < ActiveRecord::Base
  attr_accessible :token, :session_type, :driver_id, :track_id, :race_id, :winner, :screenshot_ids

  has_many :laps
  has_many :screenshots

  belongs_to :track
  belongs_to :driver
  belongs_to :race

  before_save :set_token

  def name
    "#{driver.try(:name)} on #{track.try(:name)} at #{Time.at(token.to_i(36))}"
  end

  def average_lap
    laps.average(:total)
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

  def set_token
    self.token = Session::generate_token if self.token.blank?
  end

  def self.register(params)
    driver = Driver.find_or_create_by_name(params[:driver])
    track = Track.find_or_create_by_length(params[:track])
    Session.new(:driver_id => driver.id, :track_id => track.id, :session_type => params[:type])
  end

end
