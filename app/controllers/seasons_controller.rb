class SeasonsController < ApplicationController

  before_filter :find_season, :only => [ :show ]
  before_filter :menu

  def index
  end

  def show
    @leaderboard = {}

    @season.races.each do |race|
      race.sessions.includes(:laps).order('laps.total').limit(10).each_with_index do |s, i|
        driver = Driver.find(s.driver_id)
        @leaderboard[driver] ||= 0
        @leaderboard[driver] += Race::POINTS[i]
      end
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
