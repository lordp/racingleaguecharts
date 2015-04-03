class SayWhat::SuperLeaguesController < ApplicationController
  before_filter :find_super_league, :only => [ :show, :edit, :update, :destroy ]

  def index
    @super_leagues = SuperLeague.order(:name)
  end

  def show
  end

  def new
    @super_league = SuperLeague.new
  end

  def edit
  end

  def create
    @super_league = SuperLeague.new(super_league_params)
    @super_league.save!
    redirect_to(say_what_super_league_path(@super_league), :notice => 'Super League was successfully created.')
  rescue
    render "new"
  end

  def update
    @super_league.update!(super_league_params)
    redirect_to(say_what_super_league_path(@super_league), :notice => 'Super League was successfully updated.')
  rescue
    render "edit"
  end

  def destroy
    @super_league.destroy
    redirect_to(say_what_super_leagues_url, :notice => 'Super League deleted')
  end

  private

    def find_super_league
      @super_league = SuperLeague.find(params[:id].to_i)
    end

    def super_league_params
      params.require(:super_league).permit(:name, :disabled)
    end

end
