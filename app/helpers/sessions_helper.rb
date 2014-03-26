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
      :points => Race::POINTS[index] || 0
    }
    if race.nil?
      show = parts.select { |key| [:driver, :race, :track, :laps].include?(key) }
    else
      if race.time_trial
        show = parts.select { |key| [:driver, :time, :weather, :points].include?(key) }
      else
        show = parts.select { |key| [:driver, :laps].include?(key) }
      end
    end

    show.map do |key, value|
      "#{content_tag('strong', "#{key.capitalize}:")} #{value}"
    end.join(', ').html_safe
  end

  def time_link(session, race)
    lap = session.laps.first
    link_to(nice_time(lap.try(:total)), "#{race.thing}#{lap.thing}")
  end

  def top_ten_to_reddit_table(sessions)
    table = "Q|Driver|Time\n-|-|-\n"
    sessions.each_with_index do |session, index|
      lap = session.laps.first
      table += "#{index + 1}|[](/mini-flair-#{session.driver.flair}) #{session.driver.name}|#{nice_time(lap.total)}\n"
    end

    table
  end
end
