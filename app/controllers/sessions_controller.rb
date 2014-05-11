class SessionsController < ApplicationController

  before_filter :find_session, :only => [ :show, :chart, :edit, :update, :destroy ]
  skip_before_filter :build_menu, :only => [ :register ]
  skip_before_filter :verify_authenticity_token, :only => [ :register ]
  before_filter :authorize_claimed, :only => [ :edit, :update, :destroy ]

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

  def edit
  end

  def update
    if @session.update_attributes({:session_type => params[:session][:session_type], :track_id => params[:session][:track_id]})
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
      redirect_to(user_path(current_user), :alert => 'Not authorized!') if current_user.nil? || !current_user.has_claimed?(@session.driver)
    end

end
