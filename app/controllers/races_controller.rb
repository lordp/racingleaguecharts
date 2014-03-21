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
  end

  private

    def find_race
      @race = Race.find(params[:id].to_i) if params[:id]
    end

    def menu
      build_menu(@race)
    end

end
