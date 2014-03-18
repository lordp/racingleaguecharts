class ApplicationController < ActionController::Base
  protect_from_forgery

  def build_menu(obj = nil)
    case obj
      when Session
        @race = obj.race
        build_menu(@race)
      when Race
        @season = obj.season
        @races = @season.races
        build_menu(@season)
      when Season
        @league = obj.league
        @seasons = @league.seasons
        @races = @season.races
        build_menu(@league)
      when League
        @super_league = obj.super_league
        @leagues = @super_league.leagues
        @seasons = obj.seasons
        build_menu(@super_league)
      when SuperLeague
        @super_leagues = SuperLeague.all
        @leagues = @super_league.leagues
      else
        @super_leagues = SuperLeague.all
    end
  end

  private

    def current_user
      @current_user ||= User.find(session[:user_id]) if session[:user_id]
    end
    helper_method :current_user

end
