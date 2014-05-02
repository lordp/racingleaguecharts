class SessionsController < ApplicationController

  before_filter :find_session, :only => [ :show, :chart ]
  skip_before_filter :build_menu, :only => [ :register ]

  skip_before_filter :verify_authenticity_token, :only => [ :register ]

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

  private

    def find_session
      @session = Session.find(params[:id].to_i)
    end

end
