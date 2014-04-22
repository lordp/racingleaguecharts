module SessionsHelper
  def screenshot_class(screenshot)
    screenshot.confirmed ? 'tick' : 'cross'
  end

  def short_session_info(session, race, index)
    parts = {
      :driver => session.driver.try(:name),
      :race => session.race.try(:name),
      :track => session.track.try(:name),
      :time => time_link(session, race),
      :laps => session.laps.size,
      :weather => session.is_dry ? 'Dry' : 'Wet',
      :points => Race::POINTS[index] || 0,
      :total => nice_time(session.total_time),
      :average_lap => nice_time(session.average_lap)
    }
    if race.nil?
      show = parts.select { |key| [:driver, :track, :laps].include?(key) }
    else
      if race.time_trial
        show = parts.select { |key| [:driver, :time, :weather, :points].include?(key) }
      else
        show = parts.select { |key| [:driver, :laps, :total, :average_lap].include?(key) }
      end
    end

    show.map do |key, value|
      "#{content_tag('strong', "#{key.capitalize}:")} #{value}"
    end.join(', ').html_safe
  end

  def time_link(session, race)
    lap = session.laps.first
    link_to(nice_time(lap.try(:total)), "#{race.thing}#{lap.thing}") if race && race.time_trial?
  end

  def top_ten_to_reddit_table(season_or_sessions)
    if season_or_sessions.is_a?(Season) && season_or_sessions.time_trial
      table = "Pos|Driver|Points\n-|-|-\n"
      season_or_sessions.leaderboard.each_with_index do |driver, index|
        table += "#{(index + 1).ordinalize}|#{driver[0].name}|#{driver[1]}\n"
      end
    else
      table = "Q|Driver|Time\n-|-|-\n"
      season_or_sessions.each_with_index do |session, index|
        lap = session.laps.first
        table += "#{index + 1}|[](/mini-flair-#{session.driver.flair}) #{session.driver.name}|#{nice_time(lap.total)}\n"
      end
    end

    table
  end

  def fastest_lap(lap, fastest_lap)
    if lap == fastest_lap
      "class=\"bg-success\" style=\"font-weight: bold\"".html_safe
    end
  end
end
