class TracksController < ApplicationController

  before_filter :find_track, :only => [ :show ]

  def index
    @tracks = Track.all
  end

  def show
    @sessions = @track.sessions.order(:token).page(params[:page].to_i).per(15)
  end

  private

  def find_track
    @track = Track.find(params[:id].to_i) if params[:id]
  end

end
