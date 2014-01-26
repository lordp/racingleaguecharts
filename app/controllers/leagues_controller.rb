class LeaguesController < ApplicationController

  before_filter :find_league, :only => [ :new, :show, :edit, :update ]
  before_filter :menu, :only => [ :index, :show, :new, :edit ]

  def index
  end

  def show
  end

  def new
    @league = League.new
  end

  def create
    @league = League.new(params[:league])
    if @league.save
      redirect_to(league_path(@league), :notice => "League created")
    end
  end

  def edit
  end

  def update
    if @league.save
      redirect_to(league_path(@league), :notice => "League updated")
    end
  end

  private

    def find_league
      @league = League.find(params[:id].to_i)
    end

    def menu
      build_menu(@league)
    end

end
