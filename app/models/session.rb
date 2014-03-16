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

  def self.scan_time_trial(thing, race)
    valid_tracks_regex = /Round (\d+): ([a-zA-Z ]+) in (Dry \*\*and\*\* Wet|Dry|Wet)/
    time_regex = /\[[^\d]*([\d:\.]+)\]/
    track_regex = /^[\*]*([A-Za-z ]+)(Dry|Wet)?[\* -:]*/

    leaderboard = {}
    unless thing.nil?
      reddit = Snoo::Client.new
      post = reddit.get_comments({ :link_id => thing, :rand => Time.now.to_i })

      global_dry_wet = nil
      tracks = post.parsed_response.first['data']['children'][0]['data']['selftext'].scan(valid_tracks_regex)
      tracks.each do |track|
        leaderboard ||= {}
        if track[2] == 'Dry **and** Wet'
          leaderboard['dry'] ||= {}
          leaderboard['wet'] ||= {}
        else
          global_dry_wet = track[2].downcase
          leaderboard[global_dry_wet] ||= {}
        end
      end

      post.parsed_response.last['data']['children'].each do |p|
        track = nil
        p['data']['body'].split(/\n/).each do |line|
          next if line.empty?

          unless line.match(track_regex).nil?
            track = line.match(track_regex)[1].match("(#{tracks.collect { |t| t[1] }.join('|')})( (Dry|Wet))?.*")
          end

          next if track.nil?

          dry_wet = track[3].nil? ? global_dry_wet : track[3].downcase
          time = line.scan(time_regex)
          unless time.empty?
            track = tracks.find { |t| t[1] == track[1] }
            time = time.first.map { |t| Session.convert_lap_to_seconds(t) }.min
            unless track.nil?
              leaderboard[dry_wet][p['data']['author']] = time
            end
          end
        end
      end

      leaderboard.each do |dry_wet, laps|
        laps.each do |driver, time|
          driver = Driver.find_or_create_by_name(driver)
          session = race.sessions.find_or_create_by_driver_id_and_is_dry(driver.id, dry_wet == "dry")
          session.laps.find_or_create_by_lap_number_and_total(:lap_number => 0, :total => time)
        end
      end
    end

  end

  def self.convert_lap_to_seconds(lap)
    time = lap.match(/((\d)[:.])?([\d\.:]+)/)
    ((time[2].to_i * 60) + time[3].gsub(/:/, '.').to_f).round(3)
  end

end
app/controllers/sessions_controller.rb
app/models/race.rb
app/models/session.rb
app/views/races/_form.html.erb
app/views/races/show.html.erb
config/routes.rb
db/schema.rb