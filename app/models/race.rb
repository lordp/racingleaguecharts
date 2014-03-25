class Race < ActiveRecord::Base
  attr_accessible :name, :session_ids, :track_id, :season_id, :time_trial, :is_dry, :thing

  has_many :sessions
  belongs_to :track
  belongs_to :season

  POINTS = [ 25, 18, 15, 12, 10, 8, 6, 4, 2, 1 ]

  def full_name
    nm = []
    nm << (self.season.nil? || self.season.league.nil? ? 'No league' : self.season.league.name)
    nm << (self.season.nil? ? 'No season' : self.season.name)
    nm << (self.name.nil? ? 'No name' : self.name)

    nm.join('/')
  end

  def adjust_sessions(driver_ids)
    driver_ids.map!(&:to_i)

    current = self.sessions.collect(&:driver_id)
    added = driver_ids - current
    removed = current - driver_ids

    added.each do |driver|
      self.sessions.find_or_create_by_driver_id(:driver_id => driver)
    end

    removed.each do |driver|
      self.sessions.where(:driver_id => driver).destroy_all
    end
  end

  def scan_time_trial
    valid_tracks_regex = /Round (\d+): ([a-zA-Z ]+) in (Dry \*\*and\*\* Wet|Dry|Wet)/
    time_regex = /\[[^\d]*([\d:\.]+)\]/
    track_regex = /^[\*]*([A-Za-z ]+)(Dry|Wet)?[\* -:]*/

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
            time = time.map { |t| convert_lap_to_seconds(t.first) }.min
            unless track.nil?
              leaderboard[dry_wet][p['data']['author']] = time
            end
          end
        end
      end

      race_dry_wet = is_dry ? 'dry' : 'wet'
      leaderboard.each do |dry_wet, laps|
        next unless race_dry_wet == dry_wet
        laps.each do |driver, time|
          driver = Driver.find_or_create_by_name(driver)
          session = self.sessions.find_or_initialize_by_driver_id_and_is_dry(driver.id, is_dry)
          session.track_id = track_id
          session.save
          lap = session.laps.find_or_create_by_lap_number(:lap_number => 0)
          lap.total = time
          lap.save
        end
      end
    end
  end

  def convert_lap_to_seconds(lap)
    time = lap.match(/((\d)[:.])?([\d\.:]+)/)
    ((time[2].to_i * 60) + time[3].gsub(/:/, '.').to_f).round(3)
  end

end
