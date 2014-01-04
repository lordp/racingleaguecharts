class SessionsController < ApplicationController

  def index
    @sessions = Session.order(:token)
  end

  def show
    @session = Session.find(params[:id])
  end

  def chart
    @session = Session.find(params[:id])
  end
end
