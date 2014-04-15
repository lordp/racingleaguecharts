class Race < ActiveRecord::Base
  attr_accessible :name, :session_ids, :track_id, :season_id, :time_trial, :is_dry, :thing, :fia, :driver_session_ids, :existing_driver_session_ids
  attr_accessor :driver_session_ids, :existing_driver_session_ids

  has_many :sessions
  belongs_to :track
  belongs_to :season

  before_save :nullify_thing
  after_save :adjust_sessions

  validates_presence_of :name, :track_id, :season_id

  POINTS = [ 25, 18, 15, 12, 10, 8, 6, 4, 2, 1 ]
  F1_MAP = {
    'vettel'          => 393,
    'ricciardo'       => 394,
    'rosberg'         => 395,
    'hamilton'        => 396,
    'hulkenberg'      => 397,
    'alonso'          => 398,
    'button'          => 399,
    'kevin_magnussen' => 400,
    'raikkonen'       => 401,
    'bottas'          => 402,
    'massa'           => 403,
    'vergne'          => 404,
    'kvyat'           => 405,
    'perez'           => 406,
    'grosjean'        => 407,
    'sutil'           => 408,
    'gutierrez'       => 409,
    'chilton'         => 410,
    'kobayashi'       => 411,
    'ericsson'        => 412,
    'jules_bianchi'   => 413,
    'maldonado'       => 414,
  }


  def full_name
    nm = []
    nm << (self.season.nil? || self.season.league.nil? ? 'No league' : self.season.league.name)
    nm << (self.season.nil? ? 'No season' : self.season.name)
    nm << (self.name.nil? ? 'No name' : self.name)

    nm.join('/')
  end

  def adjust_sessions
    unless driver_session_ids.nil?
      driver_session_ids.reject!(&:blank?).map!(&:to_i)

      current = self.sessions.collect(&:driver_id)
      added = driver_session_ids - current
      removed = current - driver_session_ids

      added.each do |driver|
        session = self.sessions.find_or_initialize_by_driver_id(:driver_id => driver)
        session.track_id = self.track_id
        session.save
      end

      removed.each do |driver|
        self.sessions.where(:driver_id => driver).each { |s| s.update_attribute(:race_id, nil) }
      end
    end

    unless existing_driver_session_ids.nil?
      existing_driver_session_ids.reject!(&:blank?).map!(&:to_i)

      current = self.sessions.collect(&:id)
      Session.find((existing_driver_session_ids - current)).each do |session|
        session.update_attribute(:race_id, self.id)
      end
    end
  end

  def scan_time_trial
    valid_tracks_regex = /Round (\d+): ([a-zA-Z ]+) in (([Dd]ry|[Ww]et) \*\*and\*\* ([Dd]ry|[Ww]et)|[Dd]ry|[Ww]et)/
    time_regex = /\[[^\d]*([\d:\.]+)\]/

    leaderboard = {}
    unless thing.nil?
      if thing =~ /^http/
        uri = URI(thing)
        link_id = uri.path.split(/\//)[4]
      else
        link_id = thing
      end

      conf = YAML.load(File.open("#{Rails.root}/config/reddit.yml").read)

      reddit = Snoo::Client.new({ :useragent => conf[:useragent], :username => conf[:username], :password => conf[:password] })
      post = reddit.get_comments({ :link_id => link_id })

      global_dry_wet = nil
      valid_track = post.parsed_response.first['data']['children'][0]['data']['selftext'].match(valid_tracks_regex)

      leaderboard ||= {}
      if valid_track[4].nil? && valid_track[5].nil?
        global_dry_wet = valid_track[3].downcase
        leaderboard[global_dry_wet] ||= {}
      else
        leaderboard['dry'] ||= {}
        leaderboard['wet'] ||= {}
      end

      post.parsed_response.last['data']['children'].each do |p|
        next if p['data']['author'] == 'TimeTrialBot'
        p['data']['body'].split(/\n/).each do |line|
          next if line.empty?

          dry_wet = line.match(/[Dd]ry|[Ww]et/)
          dry_wet = dry_wet.nil? ? global_dry_wet : dry_wet[0].downcase

          next if dry_wet.nil?

          time = line.scan(time_regex)
          unless time.empty?
            time = time.map { |t| convert_lap_to_seconds(t.first) }.min
            leaderboard[dry_wet][p['data']['author']] = { :time => time, :thing => p['data']['id'], :flair => p['data']['author_flair_css_class'] }
            Rails.logger.info("DRY/WET: #{dry_wet}, DRIVER: #{p['data']['author']}, TIME: #{time}")
          end
        end
      end

      race_dry_wet = is_dry ? 'dry' : 'wet'
      leaderboard[race_dry_wet].each do |driver, lap_info|
        driver = Driver.find_or_create_by_name(driver)
        driver.update_attribute(:flair, lap_info[:flair].split(/ /).first) unless lap_info[:flair].nil?
        session = self.sessions.find_or_initialize_by_driver_id_and_is_dry(driver.id, is_dry)
        session.track_id = track_id
        session.save
        lap = session.laps.find_or_create_by_lap_number(:lap_number => 0)
        lap.total = lap_info[:time]
        lap.thing = lap_info[:thing]
        lap.save
      end
    end
  end

  def convert_lap_to_seconds(lap)
    time = lap.match(/((\d+)[:.])?([\d\.:]+)/)
    ((time[2].to_i * 60) + time[3].gsub(/:/, '.').to_f).round(3)
  end

  def nullify_thing
    self.thing = nil if self.thing.blank?
  end

  def scan_f1(race_number)
    response = HTTParty.get("http://ergast.com/api/f1/2014/#{race_number}/laps.json?limit=2000")
    if response.code == 200
      response.parsed_response['MRData']['RaceTable']['Races'].first['Laps'].collect { |l| l['Timings'] }.each_with_index do |lap, index|
        lap.each do |lap_info|
          session = self.sessions.find_or_create_by_driver_id(F1_MAP[lap_info['driverId']])
          this_lap = session.laps.find_or_initialize_by_lap_number(:lap_number => index)
          this_lap.total = convert_lap_to_seconds(lap_info['time'])
          this_lap.save
        end
      end
    end
  end

end
