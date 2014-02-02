class ScreenshotsController < ApplicationController
  before_filter :find_screenshot, :only => [ :show, :edit, :update, :destroy ]
  before_filter :menu, :only => [ :index, :show, :edit, :new ]

  def index
  end

  def show
  end

  def new
    @screenshot = Screenshot.new
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
      redirect_to(edit_session_path(@screenshot.session), :notice => "Screenshot updated")
    end
  end

  def destroy
  end

  private

    def find_screenshot
      @screenshot = Screenshot.find(params[:id].to_i)
    end

    def menu
      build_menu(@screenshot)
    end

end
