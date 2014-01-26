class SessionsController < ApplicationController

  before_filter :find_session, :only => [ :show, :edit, :update, :chart ]
  before_filter :menu, :only => [ :index, :show, :new, :edit ]

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

  private

    def find_session
      @session = Session.find(params[:id].to_i)
    end

    def menu
      build_menu(@session)
    end
end
