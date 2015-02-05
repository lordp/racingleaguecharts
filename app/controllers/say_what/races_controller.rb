class SayWhat::RacesController < ApplicationController
  before_filter :find_race, :only => [ :show, :edit, :update, :destroy, :rescan ]
  before_filter :get_sessions, :only => [ :edit ]

  def index
    @races = {}
    Race.order(:created_at).each do |race|
      season = race.try(:season)
      league = season.try(:league)
      super_league = league.try(:super_league)

      super_league = 'Unknown' if super_league.nil?
      league = 'Unknown' if league.nil?
      season = 'Unknown' if season.nil?

      @races[super_league] ||= {}
      @races[super_league][league] ||= {}
      @races[super_league][league][season] ||= []
      @races[super_league][league][season] << race
    end
  end

  def show
    @sessions = if @race.time_trial
      @race.sessions.includes(:laps).order('laps.total')
    else
      @race.sessions.order(:created_at)
    end
  end

  def new
    @race = Race.new
  end

  def edit
  end

  def create
    @race = Race.new(race_params)
    @race.save!
    redirect_to(say_what_race_path(@race), :notice => 'Race was successfully created.')
  rescue
    render "new"
  end

  def update
    @race.update!(race_params)
    redirect_to(say_what_race_path(@race), :notice => 'Race was successfully updated.')
  rescue Exception => e
    Rails.logger.debug(e.inspect)
    render "edit"
  end

  def destroy
    @race.destroy
    redirect_to(say_what_races_url, :notice => 'Race deleted')
  end

  def rescan
    @race.scan_time_trial if @race.time_trial?
    redirect_to(say_what_race_path(@race), :notice => 'Thread scanned')
  end

  private

    def find_race
      @race = Race.find(params[:id].to_i)
    end

    def get_sessions
      @sessions = @race.sessions.collect(&:driver_id)
    end

    def race_params
      params.require(:race).permit(:name, :season_id, :track_id, :ac_log, :time_trial, :is_dry, :thing, :fia, :session_ids => [], :driver_session_ids => [], :existing_driver_session_ids => [])
    end

end
