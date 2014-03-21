class DriversController < ApplicationController

  def index
    @drivers = Driver.order(:name)
  end

  def show
    @driver = Driver.find(params[:id].to_i)
    @sessions = @driver.sessions.order(:token).page(params[:page].to_i).per(15)
  end

end
