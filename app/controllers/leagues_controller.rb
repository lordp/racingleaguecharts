class LeaguesController < ApplicationController
  before_filter :find_league, :only => [ :show, :generate_drivers_table, :generate_teams_table, :generate_winners_table ]

  def index
  end

  def show
  end

  def generate_drivers_table
    @table = @league.drivers.order('points DESC')
  end

  def generate_teams_table
    @table = @league.teams.sort { |a,b| a.points(@league.id) <=> b.points(@league.id) }.reverse
  end

  def generate_winners_table
    @table = @league.races.collect { |race| { 'name' => race.name, 'winner' => race.winner, 'fastest_lap' => race.fastest_lap } }.reject { |r| r['winner'].nil? }
  end

  private

    def find_league
      @league = League.find(params[:id])
    end

end
