module LeaguesHelper

  def driver_race_result(results, driver, race)
    classes = []
    title = ''

    result = results.select { |r| r.driver == driver && r.race == race }.first
    if result
      case result.position
      when -2 then
        value = 'DSQ'
        classes << 'disqualified'
      when -1 then
        value = 'Ret'
        classes << 'retired'
      when 1 then
        value = result.position
        title = pluralize(Driver::POINTS[result.position - 1], 'point')
        classes << 'first-place'
      when 2 then
        value = result.position
        title = pluralize(Driver::POINTS[result.position - 1], 'point')
        classes << 'second-place'
      when 3 then
        value = result.position
        title = pluralize(Driver::POINTS[result.position - 1], 'point')
        classes << 'third-place'
      when 4..8 then
        value = result.position
        title = pluralize(Driver::POINTS[result.position - 1], 'point')
        classes << 'fourth-to-eighth-place'
      else
        value = result.position
        classes << 'other-places'
      end

      classes << 'fastest-lap' if result.fastest_lap
      classes << 'pole-position' if result.pole_position

      value = link_to(value, edit_admin_result_path(result), :title => title)
    else
      value = link_to('-', '#result-modal-new', 'data-toggle' => 'modal', 'data-race' => race.id, 'data-driver' => driver.id, 'data-team' => driver.team_id)
    end

    content_tag('td', value, { :class => classes.join(' '), :id => "driver_#{driver.id}_race_#{race.id}" })
  end

  def team_race_points(team, race)
    team.results.where(:race_id => race).where('position between 1 and 8').inject(0) do |sum, result|
      sum += Driver::POINTS[result.position - 1]
    end
  end

  def full_country(shorthand)
    case shorthand
    when nil then ''
    when 'us' then 'United States of America'
    when 'uk' then 'United Kingdom'
    when 'nz' then 'New Zealand'
    when 'lit' then 'Lithuania'
    else shorthand.humanize
    end
  end

end
