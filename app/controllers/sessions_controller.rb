class SessionsController < ApplicationController

  before_filter :find_race, :only => [ :edit, :new ]
  before_filter :find_session, :only => [ :show, :edit, :update, :chart ]
  before_filter :menu, :only => [ :index, :show, :new, :edit ]

  skip_before_filter :verify_authenticity_token, :only => [ :register ]

  def index
    @sessions = Session.order(:token).page(params[:page].to_i).per(15)
  end

  def show
  end

  def chart
  end

  def new
    @session = Session.new
  end

  def create
    params[:session][:screenshot_ids] = params[:session][:screenshot_ids].split(/,/)
    @session = Session.new(params[:session])
    if @session.save
      redirect_to(session_path(@session), :notice => "Session created")
    end
  end

  def edit
  end

  def update
    params[:session][:screenshot_ids] = params[:session][:screenshot_ids].split(/,/)
    @session = Session.find(params[:id].to_i)
    if @session.update_attributes(params[:session])
      redirect_to(session_path(@session), :notice => "Session updated")
    end
  end

  def register
    @session = Session.register(params)
    respond_to do |format|
      if @session.save
        format.json { render :json => { :session_id => @session.id } }
      else
        format.json { render json: @session.errors, status: :unprocessable_entity }
      end
    end
  end

  def scan_time_trial
    @leaderboard = Session.scan_time_trial(params[:thing], params[:race_id])
  end

  private

    def find_race
      @race = Race.find(params[:race_id].to_i) if params[:race_id]
    end

    def find_session
      @session = Session.find(params[:id].to_i)
    end

    def menu
      build_menu(@session)
    end
end
