class SeasonsController < ApplicationController

  before_filter :find_season, :only => [ :show, :new, :edit, :update ]
  before_filter :menu, :only => [ :index, :show, :new, :edit, :update ]

  def index
  end

  def show
  end

  def new
    @season = Season.new
  end

  def create
    @season = Season.new(params[:season])
    if @season.save
      redirect_to(season_path(@season), :notice => "Season created")
    end
  end

  def edit
  end

  def update
    if @season.save
      redirect_to(season_path(@season), :notice => "Season updated")
    end
  end

  private

    def find_season
      @season = Season.find(params[:id].to_i)
    end

    def menu
      build_menu(@season)
    end

end
