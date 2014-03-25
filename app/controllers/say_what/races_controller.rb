class SayWhat::RacesController < ApplicationController
  before_filter :find_race, :only => [ :show, :edit, :update, :destroy ]
  before_filter :get_sessions, :only => [ :edit, :new ]

  def index
    @races = Race.order(:name)
  end

  def show
    @sessions = @race.sessions.order(:created_at).page(params[:page].to_i).per(15)
  end

  def new
    @race = Race.new
  end

  def edit
  end

  def create
    @race = Race.new(params[:race])

    if @race.save
      redirect_to(say_what_race_path(@race), :notice => 'Race was successfully created.')
    else
      render "new"
    end
  end

  def update
    @race.scan_time_trial if params[:rescan]
    if @race.update_attributes(params[:race]) && @race.adjust_sessions(params[:driver_session_ids])
      redirect_to(say_what_race_path(@race), :notice => 'Race was successfully updated.')
    else
      render "edit"
    end
  end

  def destroy
    @race.destroy
    redirect_to(say_what_races_url, :notice => 'Race deleted')
  end

  private

    def find_race
      @race = Race.find(params[:id].to_i)
    end

    def get_sessions
      @sessions = @race.sessions.collect(&:driver_id)
    end

end
