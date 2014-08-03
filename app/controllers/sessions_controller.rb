class SessionsController < ApplicationController

  before_filter :find_session, :only => [ :show, :chart, :edit, :update, :destroy ]
  skip_before_filter :build_menu, :only => [ :register ]
  skip_before_filter :verify_authenticity_token, :only => [ :register ]
  before_filter :authorize_claimed, :only => [ :edit, :update, :destroy ]
  before_filter :logged_in, :only => [ :new, :create, :edit, :update, :destroy ]

  def index
    @sessions = Session.order(:created_at).page(params[:page].to_i).per(15)
  end

  def show
  end

  def chart
    @compare = Session.find(params[:compare].to_i) if params[:compare]
  end

  def register
    @session = Session.register(params)
    respond_to do |format|
      if @session.save
        format.json { render :json => { :session_id => @session.id } }
        format.xml { render :xml => { :session_id => @session.id }.to_xml(:root => 'racingleaguecharts') }
      else
        format.json { render json: @session.errors, status: :unprocessable_entity }
      end
    end
  end

  def new
    @session = Session.new
  end

  def create
    @session = Session.new(params[:session])
    if @session.save
      redirect_to(user_path(current_user), :notice => 'Session was successfully created.')
    else
      render "new"
    end
  end

  def edit
  end

  def update
    if @session.update_attributes(params[:session])
      redirect_to(user_path(current_user), :notice => 'Session details were successfully updated.')
    else
      render "edit"
    end
  end

  def destroy
    @session.destroy
    redirect_to(:back, :notice => 'Session deleted')
  end

  private

    def find_session
      @session = Session.find(params[:id].to_i)
    end

    def authorize_claimed
      if current_user
        redirect_to(user_path(current_user), :alert => 'Not authorized!') unless current_user.has_claimed?(@session.driver) || current_user.admin?
      else
        redirect_to(sign_in_users_path, :alert => 'Not authorized!')
      end
    end

end
