class RacesController < ApplicationController

  before_filter :find_race, :only => [ :show, :chart, :livetiming ]

  def index
    @races = Race.order(:created_at).page(params[:page].to_i).per(15)
  end

  def show
    @race_sessions = if @race.time_trial
      @race.sessions.includes(:laps, :fastest_lap).order('laps.total')
    else
      sessions = @race.sessions.includes(:laps, :fastest_lap)
      if params[:compare]
        sessions += Race.find(params[:compare].to_i).sessions.includes(:laps)
      end

      sessions.sort_by { |s| [-s.laps.size, s.total_time] }
    end
  end

  def chart
    @compare = Race.find(params[:compare].to_i) if params[:compare]
  end

  def without_sessions
    @races = Race.includes(:sessions).where(:sessions => { :id => nil }).where('name is not null').collect { |r| { :id => r.id, :name => r.full_name } }
    respond_to do |format|
      format.json { render :json => @races }
      format.xml { render :xml => @races.to_xml(:root => 'races') }
    end
  end

  def livetiming
  end

  private

    def find_race
      @race = Race.find(params[:id].to_i) if params[:id]
    end

end
