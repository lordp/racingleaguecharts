class SeasonsController < ApplicationController

  POINTS = [ 25, 18, 15, 12, 10, 8, 6, 4, 2, 1 ]

  before_filter :find_season, :only => [ :show, :edit, :update ]
  before_filter :menu, :only => [ :index, :show, :new, :edit, :update ]

  def index
  end

  def show
    @leaderboard = {}

    @season.races.each do |race|
      race.sessions.includes(:laps).order('laps.total').limit(10).each_with_index do |s, i|
        driver = Driver.find(s.driver_id)
        @leaderboard[driver] ||= 0
        @leaderboard[driver] += POINTS[i]
      end
    end
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
    if @season.update_attributes(params[:season])
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
