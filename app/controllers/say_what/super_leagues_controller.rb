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
    @super_league = SuperLeague.new(params[:super_league])

    if @super_league.save
      redirect_to(say_what_super_league_path(@super_league), :notice => 'Super League was successfully created.')
    else
      render "new"
    end
  end

  def update
    if @super_league.update_attributes(params[:super_league])
      redirect_to(say_what_super_league_path(@super_league), :notice => 'Super League was successfully updated.')
    else
      render "edit"
    end
  end

  def destroy
    @super_league.destroy
    redirect_to(say_what_super_leagues_url, :notice => 'Super League deleted')
  end

  private

    def find_super_league
      @super_league = SuperLeague.find(params[:id].to_i)
    end

end
