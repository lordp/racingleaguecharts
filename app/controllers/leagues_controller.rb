class LeaguesController < ApplicationController

  def index

  end

  def show
    @super_league = SuperLeague.find(params[:super_league_id].to_i)
    @league = League.find(params[:id].to_i)
    build_menu(@super_league, @league)
  end

end
