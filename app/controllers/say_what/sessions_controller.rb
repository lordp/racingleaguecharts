class SayWhat::SessionsController < ApplicationController
  before_filter :find_session, :only => [ :show, :edit, :update, :destroy ]

  def index
    @sessions = Session.order(:created_at).page(params[:page].to_i).per(15)
  end

  def show
  end

  def new
    @session = Session.new
  end

  def edit
  end

  def create
    @session = Session.new(params[:session])

    if @session.save
      redirect_to(say_what_session_path(@session), :notice => 'Session was successfully created.')
    else
      render "new"
    end
  end

  def update
    if @session.update_attributes(params[:session])
      redirect_to(say_what_session_path(@session), :notice => 'Session was successfully updated.')
    else
      render "edit"
    end
  end

  def destroy
    @session.destroy
    redirect_to(say_what_sessions_url, :notice => 'Session deleted')
  end

  private

    def find_session
      @session = Session.find(params[:id].to_i)
    end

end
