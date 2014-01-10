class RacesController < ApplicationController

  before_filter :find_race, :only => [ :edit, :update, :destroy, :show, :chart ]

  def index
    @races = Race.all
  end

  def show
  end

  def new
    @race = Race.new
  end

  def create
    params[:race].delete(:session_list)
    @race = Race.new(params[:race])
    params[:session_ids].each do |id|
      @race.sessions_attributes << { :id => id }
    end
    if @race.save
      redirect_to(races_path)
    end
  end

  def edit
  end

  def update
    params[:race].delete(:session_list)
    @race.session_ids = params[:session_ids]
    if @race.update_attributes(params[:race])
      redirect_to(races_path)
    end
  end

  def destroy
  end

  def chart
  end

  private

    def find_race
      @race = Race.find(params[:id].to_i) if params[:id]
    end

end
