class SuperLeaguesController < ApplicationController

  def show
    @super_league = SuperLeague.find(params[:id].to_i)
    build_menu(@super_league)
  end

end
