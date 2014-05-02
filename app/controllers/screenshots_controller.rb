class ScreenshotsController < ApplicationController
  before_filter :find_screenshot, :only => [ :show, :edit, :update ]

  def index
  end

  def show
  end

  def edit
  end

  def update
    if @screenshot.update_attributes(params[:screenshot])
      redirect_to(session_path(@screenshot.session), :notice => 'Screenshot was successfully updated.')
    else
      render "edit"
    end
  end

  private

    def find_screenshot
      @screenshot = Screenshot.find(params[:id].to_i)
    end

end
