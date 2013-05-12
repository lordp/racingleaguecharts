class Admin::RacesController < ApplicationController
  before_filter :find_race, :only => [ :edit, :update, :show, :destroy ]

  def index
    @races = {}
    races = Race.all
    races.each do |r|
      @races[r.league] ||= []
      @races[r.league] << r
    end
  end

  def show
  end

  def new
  end

  def create
    @race = Race.new(params[:race])

    if @race.save
      redirect_to(admin_races_path, :notice => 'Race was successfully created.')
    else
      render :action => "new"
    end
  end

  def edit
  end

  def update
    if @race.update_attributes(params[:race])
      redirect_to(admin_races_path)
    else
      render :action => "edit"
    end
  end

  def destroy
  end

  private

    def find_race
      @race = Race.find(params[:id])
    end
end
