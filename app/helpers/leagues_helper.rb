module LeaguesHelper

  def driver_race_result(driver, race)
    styles = []
    title = ''

    if result = driver.results.find_by_race_id(race)
      case result.position
      when -1 then
        value = 'Ret'
        styles << 'background: rgb(239, 207, 255)'
      when 1 then
        value = result.position
        title = pluralize(Driver::POINTS[result.position - 1], 'point')
        styles << 'background: rgb(255, 255, 191)'
      when 2 then
        value = result.position
        title = pluralize(Driver::POINTS[result.position - 1], 'point')
        styles << 'background: rgb(223, 223, 223)'
      when 3 then
        value = result.position
        title = pluralize(Driver::POINTS[result.position - 1], 'point')
        styles << 'background: rgb(255, 223, 159)'
      when 4..8 then
        value = result.position
        title = pluralize(Driver::POINTS[result.position - 1], 'point')
        styles << 'background: rgb(223, 255, 223)'
      else
        value = result.position
        styles << 'background: rgb(207, 207, 255)'
      end

      styles << 'font-style: italic' if result.fastest_lap?
      styles << 'font-weight: bold' if result.pole_position?

      value = link_to(value, edit_admin_result_path(result), :title => title)
    else
      value = link_to('-', new_admin_result_path(:race_id => race, :driver_id => driver))
    end

    content_tag('td', value, { :style => styles.join(';') })
  end

  def team_race_points(team, race)
    team.results.where(:race_id => race).reject { |result| !(1..8).include?(result.position) }.inject(0) do |sum, result|
      sum += Driver::POINTS[result.position - 1]
    end
  end

end
