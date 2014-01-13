class RacesController < ApplicationController

  before_filter :setup, :only => [ :show, :edit, :new, :index, :chart ]
  before_filter :find_race, :only => [ :edit, :update, :destroy, :show, :chart ]
  before_filter :get_sessions, :only => [ :edit, :new ]

  def index
    @races = Race.all
  end

  def show
  end

  def new
    @race = Race.new
  end

  def create
    @race = Race.new(params[:race])
    if @race.save
      redirect_to(races_path)
    end
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

  def chart
  end

  private

    def find_race
      @race = Race.find(params[:id].to_i) if params[:id]
    end

    def get_sessions
      @sessions = {}
      Session.where('track_id is not null').each do |session|
        @sessions[session.track_id || 0] ||= []
        @sessions[session.track_id || 0] << { :id => session.id, :name => session.name }
      end

      @sessions
    end

    def setup
      @season = Season.find(params[:season_id].to_i)
      @league = League.find(params[:league_id].to_i)
      @super_league = SuperLeague.find(params[:super_league_id].to_i)
      build_menu(@super_league, @league, @season)
    end

end
