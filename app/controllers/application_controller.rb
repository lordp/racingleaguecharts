class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :authorize_admin, :if => lambda { params[:controller] =~ /say_what/ }
  before_filter :build_menu

  def build_menu
    @super_leagues = SuperLeague.all
  end

  private

    def current_user
      @current_user ||= User.find(session[:user_id]) if session[:user_id]
    end
    helper_method :current_user

    def authorize
      redirect_to(sign_in_users_path, :alert => 'Not authorized!') if current_user.nil?
    end

    def authorize_admin
      redirect_to(sign_in_users_path, :alert => 'Not authorized!') if current_user.nil? || !current_user.admin?
    end
end
