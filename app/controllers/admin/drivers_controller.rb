class Admin::DriversController < ApplicationController

  before_filter :find_driver, :only => [ :edit, :update, :show, :destroy ]

  def index
    @drivers = Driver.order(:name).all
  end

  def show
  end

  def new
  end

  def create
    @driver = Driver.new(params[:driver])

    if @driver.save
      redirect_to(admin_drivers_path, :notice => 'Driver was successfully created.')
    else
      render :action => "new"
    end
  end

  def edit
  end

  def update
    if @driver.update_attributes(params[:driver])
      redirect_to(admin_drivers_path)
    else
      render :action => "edit"
    end
  end

  def destroy
  end

  private

    def find_driver
      @driver = Driver.find(params[:id])
    end

end
