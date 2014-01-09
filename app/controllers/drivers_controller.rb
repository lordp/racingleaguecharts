class DriversController < ApplicationController

  before_filter :find_driver, :except => [ :index, :create, :new ]

  def index
    @drivers = Driver.all
  end

  def show
    @sessions = @driver.sessions.order(:token).page(params[:page].to_i).per(15)
  end

  def claim
    @driver.update_attribute(:name, params[:driver][:name])
    redirect_to(drivers_path)
  end

  def new
    @driver = Driver.new
  end

  def create
    @driver = Driver.new(params[:driver])
    if @driver.save
      redirect_to(driver_path(@driver), :notice => "Driver created")
    end
  end

  def edit
  end

  def update
    if @driver.update_attributes(params[:driver])
      redirect_to(driver_path(@driver), :notice => "Driver updated")
    end
  end

  private

    def find_driver
      @driver = Driver.find(params[:id].to_i) if params[:id]
    end

end
