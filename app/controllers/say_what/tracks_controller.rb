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
    @track = Track.new(track_params)
    @track.save!
    redirect_to(say_what_track_path(@track), :notice => 'Track was successfully created.')
  rescue
    render "new"
  end

  def update
    @track.update!(track_params)
    if params[:track][:move_sessions_to].blank?
      redirect_to(say_what_track_path(@track), :notice => 'Track was successfully updated.')
    else
      redirect_to(say_what_tracks_path, :notice => 'Track was deleted and sessions moved.')
    end
  rescue
    render "edit"
  end

  def destroy
    @track.destroy
    redirect_to(say_what_tracks_url, :notice => 'Track deleted')
  end

  private

    def find_track
      @track = Track.find(params[:id].to_i)
    end

    def track_params
      params.require(:track).permit(:name, :length, :move_sessions_to)
    end

end
