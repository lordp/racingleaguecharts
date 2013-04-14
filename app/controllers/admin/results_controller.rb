class Admin::ResultsController < ApplicationController
  before_filter :find_result, :only => [ :edit, :update, :show, :destroy ]

  def index
    @results = Result.order(:race_id, :position)
  end

  def show
  end

  def new
    @result = Result.new(:race_id => params[:race_id], :driver_id => params[:driver_id])
  end

  def create
    @result = Result.new(params[:result])

    if @result.save
      redirect_to(admin_results_path, :notice => 'Result was successfully created.')
    else
      render :action => "new"
    end
  end

  def edit
  end

  def update
    if @result.update_attributes(params[:result])
      redirect_to(admin_results_path)
    else
      render :action => "edit"
    end
  end

  def destroy
  end

  private

    def find_result
      @result = Result.find(params[:id])
    end

end
