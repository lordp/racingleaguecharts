class DriversController < ApplicationController

  before_filter :find_driver, :only => [ :show, :edit, :update ]
  before_filter :authorize_claimed, :only => [ :edit, :update ]

  def index
    @drivers = Driver.order('drivers.name')
    @drivers_api = { :drivers => @drivers.includes(:user).where('users.token = ?', params[:token]).collect(&:name).compact }
    respond_to do |format|
      format.html
      format.json { render :json => @drivers_api }
      format.xml { render :xml => @drivers_api.to_xml(:root => 'racingleaguecharts') }
    end
  end

  def show
    @driver = Driver.find(params[:id].to_i)
    @sessions = @driver.sessions.order(:created_at).page(params[:page].to_i).per(15)
  end

  def edit
  end

  def update
    @driver.update!(driver_params)
    redirect_to(edit_user_path(@driver.user), :notice => 'Driver updated')
  rescue
    render('edit')
  end

  private

    def find_driver
      @driver = Driver.find(params[:id].to_i)
    end

    def authorize_claimed
      redirect_to(edit_user_path(current_user), :alert => 'Not authorized!') if current_user.nil? || !current_user.has_claimed?(@driver)
    end

    def driver_params
      params.require(:driver).permit(:name, :colour, :marker, :merge_session_ids, :aliases)
    end

end
