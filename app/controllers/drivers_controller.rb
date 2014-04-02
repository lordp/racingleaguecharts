class DriversController < ApplicationController

  before_filter :find_driver, :only => [ :show, :edit, :update ]
  before_filter :authorize_claimed, :only => [ :edit, :update ]

  def index
    @drivers = Driver.order(:name)
  end

  def show
    @driver = Driver.find(params[:id].to_i)
    @sessions = @driver.sessions.order(:token).page(params[:page].to_i).per(15)
  end

  def edit
  end

  def update
    if @driver.update_attributes(params[:driver])
      redirect_to(edit_user_path(@driver.user), :notice => 'Driver updated')
    else
      render('edit')
    end
  end

  private

    def find_driver
      @driver = Driver.find(params[:id].to_i)
    end

    def authorize_claimed
      redirect_to(edit_user_path(current_user), :alert => 'Not authorized!') if current_user.nil? || !current_user.has_claimed?(@driver)
    end

end
