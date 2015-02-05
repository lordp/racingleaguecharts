class SayWhat::SeasonsController < ApplicationController
  before_filter :find_season, :only => [ :show, :edit, :update, :destroy ]

  def index
    @seasons = Season.order(:name)
  end

  def show
  end

  def new
    @season = Season.new
  end

  def edit
  end

  def create
    @season = Season.new(season_params)
    @season.save!
    redirect_to(say_what_season_path(@season), :notice => 'Season was successfully created.')
  rescue
    render "new"
  end

  def update
    @season.update!(season_params)
    redirect_to(say_what_season_path(@season), :notice => 'Season was successfully updated.')
  rescue
    render "edit"
  end

  def destroy
    @season.destroy
    redirect_to(say_what_seasons_url, :notice => 'Season deleted')
  end

  private

    def find_season
      @season = Season.find(params[:id].to_i)
    end

    def season_params
      params.require(:season).permit(:name, :league_id, :time_trial)
    end

end
