class LeaguesController < ApplicationController

  before_filter :find_league, :only => [ :show ]
  before_filter :menu

  def index
  end

  def show
  end

  private

    def find_league
      @league = League.find(params[:id].to_i)
    end

    def menu
      build_menu(@league)
    end

end
