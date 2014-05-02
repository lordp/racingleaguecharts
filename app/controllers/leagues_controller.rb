class LeaguesController < ApplicationController

  before_filter :find_league, :only => [ :show ]

  def index
  end

  def show
  end

  private

    def find_league
      @league = League.find(params[:id].to_i)
    end

end
