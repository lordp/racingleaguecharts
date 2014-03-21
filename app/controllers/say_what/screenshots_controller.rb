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
    @screenshot = Screenshot.new(params[:screenshot])

    if @screenshot.save
      redirect_to(say_what_screenshot_path(@screenshot), :notice => 'Screenshot was successfully created.')
    else
      render "new"
    end
  end

  def update
    if @screenshot.update_attributes(params[:screenshot])
      redirect_to(say_what_screenshot_path(@screenshot), :notice => 'Screenshot was successfully updated.')
    else
      render "edit"
    end
  end

  def destroy
    @screenshot.destroy
    redirect_to(say_what_screenshots_url, :notice => 'Screenshot deleted')
  end

  private

    def find_screenshot
      @screenshot = Screenshot.find(params[:id].to_i)
    end

end
