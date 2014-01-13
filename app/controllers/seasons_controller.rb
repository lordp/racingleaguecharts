class SeasonsController < ApplicationController

  before_filter :setup, :only => [ :index, :show, :new, :create, :edit, :update ]

  def index
  end

  def show
  end

  def new
    @season = Season.new
  end

  def create
    @season = Season.new(params[:season])
    @season.league = @league
    if @season.save
      redirect_to(super_league_league_season_path(@super_league, @league, @season), :notice => "Season created")
    end
  end

  def edit
    @season = Season.find(params[:id].to_i)
  end

  def update
    @season = Season.find(params[:id].to_i)
    @season.league = @league
    if @season.save
      redirect_to(super_league_league_season_path(@super_league, @league, @season), :notice => "Season updated")
    end
  end

  private

    def setup
      @season = Season.find(params[:id].to_i) if params[:id]
      @league = League.find(params[:league_id].to_i)
      @super_league = SuperLeague.find(params[:super_league_id].to_i)
      build_menu(@super_league, @league, @season)
    end

end
