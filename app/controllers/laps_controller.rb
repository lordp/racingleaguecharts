class LapsController < ApplicationController
  skip_before_filter :verify_authenticity_token, :only => [ :create ]
  skip_before_filter :build_menu

  def create
    lap = Lap.find_or_initialize_by(:session_id => params[:session_id], :lap_number => params[:lap_number])
    lap.sector_1 = params[:sector_1].to_f if params[:sector_1]
    lap.sector_2 = params[:sector_2].to_f if params[:sector_2]
    lap.total    = params[:total].to_f if params[:total]
    lap.sector_3 = lap.total - (lap.sector_1 + lap.sector_2) if lap.total && lap.sector_1 && lap.sector_2

    lap.fuel = params[:fuel].to_f if params[:fuel]
    lap.speed = params[:speed].to_f if params[:speed]
    lap.position = params[:position].to_i if params[:position]

    respond_to do |format|
      if lap.save
        format.json { render :json => { :lap_id => lap.id } }
        format.xml { render :xml => { :lap_id => lap.id }.to_xml(:root => 'racingleaguecharts') }
      else
        format.json { render json: @lap.errors, status: :unprocessable_entity }
      end
    end
  end
end
