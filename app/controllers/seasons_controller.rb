class SeasonsController < ApplicationController

  def index
  end

  def show
    @season = Season.find(params[:id].to_i)
    @league = League.find(params[:league_id].to_i)
    @super_league = SuperLeague.find(params[:super_league_id].to_i)
    build_menu(@super_league, @league, @season)
  end

  def new
  end

  def create
  end

  def edit
  end

  def update
  end
end
