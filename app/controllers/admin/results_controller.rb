class Admin::ResultsController < ApplicationController
  before_filter :find_result, :only => [ :edit, :update, :show, :destroy ]

  def index
    @results = {}
    results = Result.order(:race_id, 'position = -1', :position)
    old_race = nil
    results.each do |r|
      @results[r.race.league] ||= {}
      @results[r.race.league][r.race] ||= []
      @results[r.race.league][r.race] << {
        :id            => r.id,
        :position      => r.position,
        :driver        => r.driver,
        :team          => r.team,
        :fastest_lap   => r.fastest_lap,
        :pole_position => r.pole_position
      }
    end
  end

  def show
  end

  def new
    @result = Result.new(:race_id => params[:race_id], :driver_id => params[:driver_id])
  end

  def create
    @result = Result.create(params[:result])
    expire_fragment("team_#{@result.team_id}_race_#{@result.race_id}")
    respond_to do |format|
      format.html { redirect_to(admin_results_path()) }
      format.js
    end
  end

  def edit
  end

  def update
    if @result.update_attributes(params[:result])
      redirect_to(admin_results_path)
    else
      render :action => "edit"
    end
  end

  def destroy
  end

  private

    def find_result
      @result = Result.find(params[:id])
    end

end
