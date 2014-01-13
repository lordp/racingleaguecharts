class SessionsController < ApplicationController

  def index
    @sessions = Session.order(:token).page(params[:page].to_i).per(15)
  end

  def show
    @session = Session.find(params[:id])
  end

  def chart
    @session = Session.find(params[:id])
  end

  def new
    @session = Session.new
  end

  def create
    @session = Session.new(params[:session])
    if @session.save
      redirect_to(session_path(@session), :notice => "Session created")
    end
  end

  def edit
    @session = Session.find(params[:id].to_i)
  end

  def update
    @session = Session.find(params[:id].to_i)
    if @session.update_attributes(params[:session])
      redirect_to(session_path(@session), :notice => "Session updated")
    end
  end
end
