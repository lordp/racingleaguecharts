class SeasonsController < ApplicationController

  before_filter :find_season, :only => [ :show ]

  def index
  end

  def show
  end

  private

    def find_season
      @season = Season.find(params[:id].to_i)
    end

end
