class SayWhat::LapsController < ApplicationController
  before_filter :find_lap, :only => [ :show, :edit, :update, :destroy ]

  def index
    @laps = Lap.page(params[:page].to_i).per(15)
  end

  def show
  end

  def new
    @lap = Lap.new
  end

  def edit
  end

  def create
    @lap = Lap.new(lap_params)
    @lap.save!
    redirect_to(say_what_lap_path(@lap), :notice => 'Lap was successfully created.')
  rescue
    render "new"
  end

  def update
    @lap.update!(lap_params)
    redirect_to(say_what_lap_path(@lap), :notice => 'Lap was successfully updated.')
  rescue
    render "edit"
  end

  def destroy
    @lap.destroy
    redirect_to(say_what_laps_url, :notice => 'Lap deleted')
  end

  private

    def find_lap
      @lap = Lap.find(params[:id].to_i)
    end

    def lap_params
      params.require(:lap).permit(:lap_number, :sector_1, :sector_2, :sector_3, :total)
    end

end
