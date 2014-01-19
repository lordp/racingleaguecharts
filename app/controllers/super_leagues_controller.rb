class SuperLeaguesController < ApplicationController

  def show
    @super_league = SuperLeague.find(params[:id].to_i)
    build_menu(@super_league)
  end

  def new
    @super_league = SuperLeague.new
  end

  def create
    @super_league = SuperLeague.new(params[:super_league])
    if @super_league.save
      redirect_to(super_league_path(@super_league), :notice => "Super League created")
    end
  end

  def edit
    @super_league = SuperLeague.find(params[:id].to_i)
  end

  def update
    @super_league = SuperLeague.find(params[:id].to_i)
    if @super_league.save
      redirect_to(super_league_path(@super_league), :notice => "Super League updated")
    end
  end

end
