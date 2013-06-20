class LeaguesController < ApplicationController
  before_filter :find_league, :only => [ :show, :generate_drivers_table, :generate_teams_table, :generate_winners_table ]

  def index
  end

  def show
    @results = @league.results.includes(:driver, :race, :team).collect do |result|
      { driver: result.driver, race: result.race, pos: result.position, fl: result.fastest_lap, pp: result.pole_position, id: result.id }
    end
  end

  def generate_drivers_table
    @table = @league.drivers.order('points DESC')
  end

  def generate_teams_table
    @table = @league.teams.sort { |a,b| a.points(@league.id) <=> b.points(@league.id) }.reverse
  end

  def generate_winners_table
    @table = @league.races.order(:start_date).collect { |race| { 'race' => race, 'winner' => race.winner, 'fastest_lap' => race.fastest_lap } }.reject { |r| r['winner'].nil? }
  end

  private

    def find_league
      @league = League.find(params[:id])
    end

end
