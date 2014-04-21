class RacesController < ApplicationController

  before_filter :find_race, :only => [ :show, :chart ]
  before_filter :menu, :only => [ :show, :index, :chart ]

  def index
    @races = Race.all
  end

  def show
    @race_sessions = if @race.time_trial
      @race.sessions.includes(:laps).order('laps.total')
    else
      @race.sessions
    end
  end

  def chart
    @compare = Race.find(params[:compare].to_i) if params[:compare]
  end

  def without_sessions
    @races = Race.includes(:sessions).where('sessions.id is null').where('name is not null').collect { |r| [r.id, r.full_name] }
    respond_to do |format|
      format.json { render :json => @races }
    end
  end

  private

    def find_race
      @race = Race.find(params[:id].to_i) if params[:id]
    end

    def menu
      build_menu(@race)
    end

end
