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
    @driver = Driver.new(driver_params)
    @driver.save!
    redirect_to(say_what_driver_path(@driver), :notice => 'Driver was successfully created.')
  rescue
    render "new"
  end

  def update
    @driver.update!(driver_params)
    redirect_to(say_what_driver_path(@driver), :notice => 'Driver was successfully updated.')
  rescue
    render "edit"
  end

  def destroy
    @driver.destroy
    redirect_to(say_what_drivers_url, :notice => 'Driver deleted')
  end

  private

    def find_driver
      @driver = Driver.find(params[:id].to_i)
    end

    def driver_params
      params.require(:driver).permit(:name, :flair, :colour, :marker)
    end
end
