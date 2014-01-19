class TracksController < ApplicationController

  before_filter :find_track, :except => [ :index, :create, :new ]

  def index
    @tracks = Track.all
  end

  def show
    @sessions = @track.sessions.order(:token).page(params[:page].to_i).per(15)
  end

  def new
    @track = Track.new
  end

  def create
    @track = Track.new(params[:track])
    if @track.save
      redirect_to(track_path(@track), :notice => "Track created")
    end
  end

  def edit
  end

  def update
    if @track.update_attributes(params[:track])
      redirect_to(track_path(@track), :notice => "Track updated")
    end
  end

  private

  def find_track
    @track = Track.find(params[:id].to_i) if params[:id]
  end

end
