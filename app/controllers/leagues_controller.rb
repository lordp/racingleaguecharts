class LeaguesController < ApplicationController
  def index
  end

  def show
    @league = League.find(params[:id])
  end
end
