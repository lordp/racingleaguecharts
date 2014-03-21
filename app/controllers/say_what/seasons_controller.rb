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
    @season = Season.new(params[:season])

    if @season.save
      redirect_to(say_what_season_path(@season), :notice => 'Season was successfully created.')
    else
      render "new"
    end
  end

  def update
    if @season.update_attributes(params[:season])
      redirect_to(say_what_season_path(@season), :notice => 'Season was successfully updated.')
    else
      render "edit"
    end
  end

  def destroy
    @season.destroy
    redirect_to(say_what_seasons_url, :notice => 'Season deleted')
  end

  private

    def find_season
      @season = Season.find(params[:id].to_i)
    end

end
