class SayWhat::ScreenshotsController < ApplicationController
  before_filter :find_screenshot, :only => [ :show, :edit, :update, :destroy ]

  def index
    @screenshots = Screenshot.order(:created_at).page(params[:page].to_i).per(15)
  end

  def show
  end

  def new
    @screenshot = Screenshot.new
  end

  def edit
  end

  def create
    @screenshot = Screenshot.new(screenshot_params)
    @screenshot.save!
    respond_to do |format|
      format.js
      format.html { redirect_to(say_what_screenshots_path) }
    end
  rescue
    render('new')
  end

  def update
    @screenshot.update!(screenshot_params)
    redirect_to(say_what_screenshot_path(@screenshot), :notice => 'Screenshot was successfully updated.')
  rescue
    render "edit"
  end

  def destroy
    @screenshot.destroy
    redirect_to(say_what_screenshots_url, :notice => 'Screenshot deleted')
  end

  private

    def find_screenshot
      @screenshot = Screenshot.find(params[:id].to_i)
    end

    def screenshot_params
      params.require(:screenshot).permit(:image, :parsed, :session_id, :confirmed)
    end

end
