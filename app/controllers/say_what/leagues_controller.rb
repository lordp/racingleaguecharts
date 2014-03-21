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
    @league = League.new(params[:league])

    if @league.save
      redirect_to(say_what_league_path(@league), :notice => 'League was successfully created.')
    else
      render "new"
    end
  end

  def update
    if @league.update_attributes(params[:league])
      redirect_to(say_what_league_path(@league), :notice => 'League was successfully updated.')
    else
      render "edit"
    end
  end

  def destroy
    @league.destroy
    redirect_to(say_what_leagues_url, :notice => 'League deleted')
  end

  private

    def find_league
      @league = League.find(params[:id].to_i)
    end

end
