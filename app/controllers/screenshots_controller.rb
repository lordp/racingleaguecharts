class ScreenshotsController < ApplicationController
  before_filter :find_screenshot, :only => [ :show ]
  before_filter :menu

  def index
  end

  def show
  end

  private

    def find_screenshot
      @screenshot = Screenshot.find(params[:id].to_i)
    end

    def menu
      build_menu(@screenshot)
    end

end
