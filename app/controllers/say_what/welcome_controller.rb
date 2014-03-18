class SayWhat::WelcomeController < ApplicationController
  before_filter :authorize

  def index
  end
end
