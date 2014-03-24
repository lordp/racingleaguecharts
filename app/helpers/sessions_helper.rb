module SessionsHelper
  def screenshot_class(screenshot)
    screenshot.confirmed ? "tick" : "cross"
  end

  def short_session_info(session, race, index)
    parts = {
      :driver => session.driver.try(:name),
      :race => session.race.try(:name),
      :track => session.track.try(:name),
      :time => nice_time(session.laps.first.try(:total)),
      :laps => session.laps.size,
      :weather => session.is_dry ? 'Dry' : 'Wet',
      :points => Race::POINTS[index] || 0
    }
    if !race.nil?
      if race.time_trial
        show = parts.select { |key, value| [:driver, :time, :weather, :points].include?(key) }
      else
        show = parts.select { |key, value| [:driver, :laps].include?(key) }
      end
    else
      show = parts.select { |key, value| [:driver, :race, :track, :laps].include?(key) }
    end

    show.map do |key, value|
      "#{content_tag('strong', "#{key.capitalize}:")} #{value}"
    end.join(', ').html_safe
  end
end
