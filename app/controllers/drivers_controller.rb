class DriversController < ApplicationController

  before_filter :find_driver, :except => [ :index ]

  def index
    @drivers = Driver.all
  end

  def show
  end

  def claim
    @driver.update_attribute(:name, params[:driver][:name])
    redirect_to(drivers_path)
  end

  private

    def find_driver
      @driver = Driver.find(params[:id].to_i) if params[:id]
      @driver = Driver.find(params[:driver_id].to_i) if params[:driver_id]
    end

end
