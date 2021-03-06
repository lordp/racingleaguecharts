class SayWhat::SessionsController < ApplicationController
  before_filter :find_session, :only => [ :show, :edit, :update, :destroy ]
  before_filter :fix_screenshots, :only => [ :create, :update ]

  def index
    @sessions = Session.order(:created_at).page(params[:page].to_i).per(15)
  end

  def show
  end

  def new
    @session = Session.new
  end

  def edit
  end

  def create
    @session = Session.new(session_params)
    @session.save!
    redirect_to(say_what_session_path(@session), :notice => 'Session was successfully created.')
  rescue
    render "new"
  end

  def update
    @session.update!(session_params)
    redirect_to(say_what_session_path(@session), :notice => 'Session was successfully updated.')
  rescue
    render "edit"
  end

  def destroy
    @session.destroy
    redirect_to(say_what_sessions_url, :notice => 'Session deleted')
  end

  private

    def find_session
      @session = Session.find(params[:id].to_i)
    end

    def fix_screenshots
      params[:session][:screenshot_ids] = params[:session][:screenshot_ids].split(/,/).reject(&:blank?).collect(&:to_i)
    end

    def session_params
      params.require(:session).permit(:driver_id, :race_id, :track_id, :winner, :grid_position, :vehicle, :ballast, :screenshot_ids => [])
    end

end
