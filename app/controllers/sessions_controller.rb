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
end
