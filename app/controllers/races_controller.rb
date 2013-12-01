class RacesController < ApplicationController

  before_filter :find_race, :only => [ :edit, :update, :destroy, :show ]

  def index
    @races = Race.all
  end

  def show
  end

  def new
  end

  def create
  end

  def edit
  end

  def update
    if @race.update_attributes(params[:race])
      redirect_to(races_path)
    end
  end

  def destroy
  end

  private

    def find_race
      @race = Race.find(params[:id].to_i) if params[:id]
    end

end
