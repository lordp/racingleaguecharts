class Race < ActiveRecord::Base
  attr_accessor :driver_session_ids, :existing_driver_session_ids, :ac_log, :ac_log_server

  has_many :sessions
  belongs_to :track
  belongs_to :season

  before_save :nullify_thing
  after_save :adjust_sessions
  after_save :parse_assetto_corsa
  after_save :find_fastest_laps

  validates :name, :presence => true
  validates :season_id, :numericality => true
  validates :track_id, :numericality => true

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

  AC_QUALIFYING = 0
  AC_RACE       = 1

  AC_DRIVER = '.+' #'[a-zA-Z0-9\\ \|_\.]+'
  AC_SERVER_LAP_LINE = /^LAP (#{AC_DRIVER}) ([0-9:]+)$/
  AC_POSITION_LINE   = /^([0-9]+)\) (#{AC_DRIVER}) BEST: [0-9:]+ TOTAL: ([0-9:]+) Laps:([0-9]+) SesID:[0-9]+$/

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
        session = self.sessions.find_or_initialize_by(:driver_id => driver)
        session.track_id = self.track_id
        session.save
      end

      removed.each do |driver|
        self.sessions.where(:driver_id => driver).each { |s| s.update_attribute(:race_id, nil) }
      end
    end

    unless existing_driver_session_ids.blank?
      e = existing_driver_session_ids.split(/,/).reject!(&:blank?).map!(&:to_i)

      current = self.sessions.collect(&:id)
      Session.find((e - current)).each do |session|
        session.update_attribute(:race_id, self.id)
      end
      Session.find((current - e)).each do |session|
        session.update_attribute(:race_id, nil)
      end
    end
  end

  def scan_time_trial
    dry_wet_regex = /[Dd]ry|[Ww]et/
    valid_tracks_regex = /Round (\d+)[ :-]* ([a-zA-Z ]+) in ((#{dry_wet_regex}) and (#{dry_wet_regex})|#{dry_wet_regex})/
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
      valid_track = post.parsed_response.first['data']['children'][0]['data']['selftext'].gsub(/\*/, '').match(valid_tracks_regex)

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

          dry_wet = line.match(dry_wet_regex)
          dry_wet = dry_wet.nil? ? global_dry_wet : dry_wet[0].downcase
          dry_wet = 'dry' if dry_wet.nil? # assume dry

          time = line.scan(time_regex)
          unless time.empty?
            time = time.map { |t| convert_lap_to_seconds(t.first) }.min
            leaderboard[dry_wet][p['data']['author']] = { :time => time, :thing => p['data']['id'], :flair => p['data']['author_flair_css_class'] }
          end
        end
      end

      race_dry_wet = is_dry ? 'dry' : 'wet'
      leaderboard[race_dry_wet].each do |driver, lap_info|
        driver = Driver.find_or_create_by(:name =>driver)
        driver.update_attribute(:flair, lap_info[:flair].split(/ /).first) unless lap_info[:flair].nil?
        session = self.sessions.find_or_initialize_by(:driver_id => driver.id, :is_dry => is_dry)
        session.track_id = track_id
        session.session_type = 10.0
        session.save
        lap = session.laps.find_or_create_by(:lap_number => 0)
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

  def calculate_delta(last_lap, this_lap)
    (convert_lap_to_seconds(this_lap) - convert_lap_to_seconds(last_lap)).round(3)
  end

  def nullify_thing
    self.thing = nil if self.thing.blank?
  end

  def scan_f1(race_number, offset = 0)
    response = HTTParty.get("http://ergast.com/api/f1/2014/#{race_number}/laps.json?limit=1000&offset=#{offset}")
    if response.code == 200
      data = response.parsed_response['MRData']
      data['RaceTable']['Races'].first['Laps'].collect { |l| [ l['number'], l['Timings'] ] }.each do |index, lap|
        lap.each do |lap_info|
          session = self.sessions.find_or_create_by(:driver_id => F1_MAP[lap_info['driverId']])
          this_lap = session.laps.find_or_initialize_by(:lap_number => (index.to_i - 1))
          this_lap.total = convert_lap_to_seconds(lap_info['time'])
          this_lap.save
        end
      end
      if data['total'].to_i > offset + 1000
        self.scan_f1(race_number, offset + 1000)
      end
    end
  end

  def get_stats()
    stats = { :speed => [], :fuel => []}
    self.sessions.each do |s|
      stats[:speed].push({ :value => s.top_speed, :name => s.driver.name, :units => 'km/h' })
      stats[:fuel].push({ :value => s.fuel_remaining, :name => s.driver.name, :units => 'litres' })
    end
    stats
  end

  def get_ancestors
    ancestors = {}
    if season = self.season
      ancestors[:season] = self.season_id
      if league = season.league
        ancestors[:league] = season.league_id
        if league.super_league
          ancestors[:superleague] = league.super_league_id
        end
      end
    end
    ancestors
  end

  def winner
    self.winner_session.first.try(:driver).try(:name) || 'Unknown'
  end

  def laps
    self.winner_session.first.try(:laps).try(:count)
  end

  def winner_session
    winner_session = self.sessions.where(:winner => true)
    if winner_session.empty?
      winner_session = self.sessions.sort_by { |s| [-s.laps.size, s.total_time] }
    end
    winner_session
  end

  def super_league
    self.try(:season).try(:league).try(:super_league)
  end

  def league
    self.try(:season).try(:league)
  end

  def parse_assetto_corsa
    return if self.ac_log.nil?

    if self.ac_log_server == '1'
      parse_assetto_corsa_server
    else
      parse_assetto_corsa_player
    end
  end

  def parse_assetto_corsa_server
    laps = {}
    grid_position = {}
    state = nil

    File.open(self.ac_log.tempfile).each do |line|
      line.strip!

      /^TYPE=QUALIFY$/.match(line) do
        state = AC_QUALIFYING
        grid_position = {}
      end

      /^TYPE=RACE$/.match(line) do
        state = AC_RACE
        laps = {}
      end

      if state == AC_QUALIFYING
        AC_POSITION_LINE.match(line) do |lap|
          driver    = lap[2]
          pos       = lap[1].to_i

          grid_position[driver] ||= nil
          grid_position[driver] = pos
        end
      else
        AC_POSITION_LINE.match(line) do |lap|
          driver    = lap[2]
          pos       = lap[1].to_i
          lap_count = lap[4].to_i
          total     = lap[3]

          next unless lap_count > 0

          laps[driver] ||= []

          if lap_count > 1
            laps[driver][lap_count - 1] = { :time => calculate_delta(laps[driver][lap_count - 2][:total], total), :pos => pos, :total => total }
          else
            laps[driver][lap_count - 1] = { :time => convert_lap_to_seconds(total), :pos => pos, :total => total }
          end
        end

        if line.strip == 'RESTARTING SESSION'
          laps = {}
        end
      end
    end

    laps.each do |driver_id, laps_info|
      driver = Driver.find_or_create_by(:name => driver_id)
      s = self.sessions.find_or_create_by(:driver_id => driver.id)
      s.update_attribute(:grid_position, grid_position[driver_id]) unless grid_position[driver_id].nil?
      s.update_attribute(:track_id, self.track_id)
      laps_info.each_with_index do |lap, index|
        next if lap.nil?
        l = s.laps.find_or_create_by(:lap_number => index)
        l.total = lap[:time]
        l.position = lap[:pos]
        l.save
      end
    end
  end

  def parse_assetto_corsa_player
    laps = {}
    drivers = []
    found_race = false
    last_car_id = nil
    grid_driver = nil
    grid_driver_pos = 0
    grid_line_found = false
    grid_position = []
    File.open(self.ac_log.tempfile).each do |line|
      line.strip!
      found_race = true if line.match(/NAME=Race/)
      next unless found_race

      # Reset variables if another race start line is found
      if line.match(/NAME=Race/)
        laps = {}
        drivers = []
        last_car_id = nil
        grid_driver = nil
        grid_driver_pos = 0
        grid_line_found = false
        grid_position = []
      end

      /CAR ID:([\d]+) : ([^\r\n]+)/.match(line) do |car|
        car_id = car[1].to_i
        drivers[car_id] = car[2]
        grid_position << car_id
        last_car_id = car_id unless grid_line_found
      end

      /Setting my grid position at:(\d+)/.match(line) do |pos|
        grid_line_found = true
        grid_driver = drivers[last_car_id]
        grid_driver_pos = pos[1].to_i
      end

      /goToSpawnPosition START/.match(line) do
        last_car_id.downto(1).each do |car_id|
          drivers[car_id] = drivers[car_id - 1]
        end
        drivers[0] = grid_driver

        grid_position.map! { |gp| gp < last_car_id ? gp + 1 : gp }
        grid_position[grid_driver_pos] = 0
      end

      /P: ([\d]+) : ([\d]+) \| ([\d]+) LT:([\d]+) LC:([\d]+)/.match(line) do |lap|
        next if lap[5].to_i == 0
        driver = lap[2]
        laps[driver] ||= []
        lap_no = lap[5].to_i - 1
        next unless laps[driver][lap_no].nil?
        lap_time = if lap_no > 0
                     lap[4].to_i - laps[driver][lap_no - 1][:total]
                   else
                     lap[4].to_i
                   end
        laps[driver][lap_no] = { :time => lap_time, :total => lap[4].to_i, :pos => lap[1].to_i + 1 } if laps[driver][lap_no].nil?
      end
    end

    laps.each do |driver_id, laps_info|
      driver = Driver.find_or_create_by(:name => drivers[driver_id.to_i])
      s = self.sessions.find_or_create_by(:driver_id => driver.id)
      s.update_attribute(:grid_position, grid_position.index(driver_id.to_i) + 1) unless grid_position.index(driver_id.to_i).nil?
      s.update_attribute(:track_id, self.track_id)
      laps_info.each_with_index do |lap, index|
        next if lap.nil?
        l = s.laps.find_or_create_by(:lap_number => index)
        l.total = lap[:time] / 1000.0
        l.position = lap[:pos]
        l.save
      end
    end

  end

  def has_sectors?
    sessions.collect(&:has_sectors?).include?(true)
  end

  def has_speed?
    sessions.collect(&:has_speed?).include?(true)
  end

  def has_fuel?
    sessions.collect(&:has_fuel?).include?(true)
  end

  def has_position?
    sessions.collect(&:has_position?).include?(true)
  end

  def find_fastest_laps
    sessions.each(&:save)
  end

end
