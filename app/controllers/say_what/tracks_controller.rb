class SayWhat::TracksController < ApplicationController
  before_filter :find_track, :only => [ :show, :edit, :update, :destroy ]

  def index
    @tracks = Track.order(:name)
  end

  def show
  end

  def new
    @track = Track.new
  end

  def edit
  end

  def create
    @track = Track.new(params[:track])

    if @track.save
      redirect_to(say_what_track_path(@track), :notice => 'Track was successfully created.')
    else
      render "new"
    end
  end

  def update
    if @track.update_attributes(params[:track])
      redirect_to(say_what_track_path(@track), :notice => 'Track was successfully updated.')
    else
      render "edit"
    end
  end

  def destroy
    @track.destroy
    redirect_to(say_what_tracks_url, :notice => 'Track deleted')
  end

  private

    def find_track
      @track = Track.find(params[:id].to_i)
    end

end
