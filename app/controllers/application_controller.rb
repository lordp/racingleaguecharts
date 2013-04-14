class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :setup

  private

    def setup
      @leagues = League.all
    end

end
