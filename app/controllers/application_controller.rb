class ApplicationController < ActionController::Base
  protect_from_forgery

  def build_menu(super_league = nil, league = nil, season = nil, race = nil)
    @super_leagues = SuperLeague.all
    @leagues = super_league.leagues if super_league
    @seasons = league.seasons if league
    @races = season.races if season
  end

end
