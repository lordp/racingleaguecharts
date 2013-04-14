class Admin::LeaguesController < ApplicationController
  before_filter :find_league, :only => [ :edit, :update, :show, :destroy ]

  def index
    @leagues = League.all
  end

  def show
  end

  def new
  end

  def create
    @league = League.new(params[:league])

    if @league.save
      redirect_to(admin_leagues_path, :notice => 'League was successfully created.')
    else
      render :action => "new"
    end
  end

  def edit
  end

  def update
    if @league.update_attributes(params[:league])
      redirect_to(admin_leagues_path)
    else
      render :action => "edit"
    end
  end

  def destroy
  end

  private

    def find_league
      @league = League.find(params[:id])
    end
end
