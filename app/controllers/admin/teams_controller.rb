class Admin::TeamsController < ApplicationController
  before_filter :find_team, :only => [ :edit, :update, :show, :destroy ]

  def index
    @teams = Team.all
  end

  def show
  end

  def new
    @team = Team.new(:race_id => params[:race_id], :driver_id => params[:driver_id])
  end

  def create
    @team = Team.new(params[:team])

    if @team.save
      redirect_to(admin_teams_path, :notice => 'Team was successfully created.')
    else
      render :action => "new"
    end
  end

  def edit
  end

  def update
    if @team.update_attributes(params[:team])
      redirect_to(admin_teams_path)
    else
      render :action => "edit"
    end
  end

  def destroy
  end

  private

    def find_team
      @team = Team.find(params[:id])
    end
end
