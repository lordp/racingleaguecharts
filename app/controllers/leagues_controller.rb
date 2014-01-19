class LeaguesController < ApplicationController

  before_filter :setup

  def index
  end

  def show
  end

  def new
    @league = League.new
  end

  def create
    @league = League.new(params[:league])
    @league.super_league = @super_league
    if @league.save
      redirect_to(super_league_league_path(@super_league, @league), :notice => "League created")
    end
  end

  def edit
    @league = League.find(params[:id].to_i)
  end

  def update
    @league = League.find(params[:id].to_i)
    @league.super_league = @super_league
    if @league.save
      redirect_to(super_league_league_path(@super_league, @league), :notice => "League updated")
    end
  end

  private

    def setup
      @super_league = SuperLeague.find(params[:super_league_id].to_i)
      @league = League.find(params[:id].to_i) if params[:id]
      build_menu(@super_league, @league)
    end

end
