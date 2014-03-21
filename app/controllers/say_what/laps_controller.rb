class SayWhat::LapsController < ApplicationController
  before_filter :find_lap, :only => [ :show, :edit, :update, :destroy ]

  def index
    @laps = Lap.order(:total).page(params[:page].to_i).per(15)
  end

  def show
  end

  def new
    @lap = Lap.new
  end

  def edit
  end

  def create
    @lap = Lap.new(params[:lap])

    if @lap.save
      redirect_to(say_what_lap_path(@lap), :notice => 'Lap was successfully created.')
    else
      render "new"
    end
  end

  def update
    if @lap.update_attributes(params[:lap])
      redirect_to(say_what_lap_path(@lap), :notice => 'Lap was successfully updated.')
    else
      render "edit"
    end
  end

  def destroy
    @lap.destroy
    redirect_to(say_what_laps_url, :notice => 'Lap deleted')
  end

  private

    def find_lap
      @lap = Lap.find(params[:id].to_i)
    end

end
