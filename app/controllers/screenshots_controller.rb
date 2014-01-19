class ScreenshotsController < ApplicationController
  before_filter :find_session, :only => [ :new, :create, :show, :edit, :update, :destroy ]
  before_filter :find_screenshot, :only => [ :show, :edit, :update, :destroy ]

  def index
  end

  def show
  end

  def new
    @screenshot = Screenshot.new(:session_id => @session.id)
  end

  def edit
  end

  def create
    @screenshot = Screenshot.create(params[:screenshot])
    respond_to do |format|
      format.js
    end
  end

  def update
    if @screenshot.update_attributes(params[:screenshot])
      redirect_to(edit_session_screenshot_path(@session, @screenshot), :notice => "Screenshot updated")
    end
  end

  def destroy
  end

  private

    def find_session
      @session = Session.find(params[:session_id].to_i) if params[:session_id]
    end

    def find_screenshot
      @screenshot = Screenshot.find(params[:id].to_i)
    end

end
