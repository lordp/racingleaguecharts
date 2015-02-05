class ScreenshotsController < ApplicationController
  before_filter :find_screenshot, :only => [ :show, :edit, :update ]

  def index
  end

  def show
  end

  def edit
  end

  def update
    @screenshot.update!(screenshot_params)
    redirect_to(session_path(@screenshot.session), :notice => 'Screenshot was successfully updated.')
  rescue
    render "edit"
  end

  private

    def find_screenshot
      @screenshot = Screenshot.find(params[:id].to_i)
    end

    def screenshot_params
      params.require(:screenshot).permit(:confirmed, :parsed)
    end

end
