class SayWhat::DriversController < ApplicationController
  before_filter :find_driver, :only => [ :show, :edit, :update, :destroy ]

  def index
    @drivers = Driver.order(:name)
  end

  def show
    @sessions = @driver.sessions.order(:created_at).page(params[:page].to_i).per(15)
  end

  def new
    @driver = Driver.new
  end

  def edit
  end

  def create
    @driver = Driver.new(params[:driver])

    if @driver.save
      redirect_to(say_what_driver_path(@driver), :notice => 'Driver was successfully created.')
    else
      render "new"
    end
  end

  def update
    if @driver.update_attributes(params[:driver])
      redirect_to(say_what_driver_path(@driver), :notice => 'Driver was successfully updated.')
    else
      render "edit"
    end
  end

  def destroy
    @driver.destroy
    redirect_to(say_what_drivers_url, :notice => 'Driver deleted')
  end

  private

    def find_driver
      @driver = Driver.find(params[:id].to_i)
    end
end
