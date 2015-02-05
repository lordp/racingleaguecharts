class SayWhat::LeaguesController < ApplicationController
  before_filter :find_league, :only => [ :show, :edit, :update, :destroy ]

  def index
    @leagues = League.order(:name)
  end

  def show
  end

  def new
    @league = League.new
  end

  def edit
  end

  def create
    @league = League.new(league_params)
    @league.save!
    redirect_to(say_what_league_path(@league), :notice => 'League was successfully created.')
  rescue
    render "new"
  end

  def update
    @league.update!(league_params)
    redirect_to(say_what_league_path(@league), :notice => 'League was successfully updated.')
  rescue
    render "edit"
  end

  def destroy
    @league.destroy
    redirect_to(say_what_leagues_url, :notice => 'League deleted')
  end

  private

    def find_league
      @league = League.find(params[:id].to_i)
    end

    def league_params
      params.require(:league).permit(:name, :super_league_id)
    end
end
