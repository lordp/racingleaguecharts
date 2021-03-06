class UsersController < ApplicationController

  before_filter :authorize, :only => [ :edit, :update ]
  before_filter :filter_token, :only => [ :reset_password, :do_reset_password ]

  def show
    @user = User.find(params[:id].to_i)
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    @user.save!
    redirect_to(root_url, :notice => 'Signed up!')
  rescue
    render('new')
  end

  def edit
    @user = current_user
  end

  def update
    @user = current_user
    @user.update!(user_params)
    redirect_to(edit_user_path(@user), :notice => 'User details updated')
  rescue
    render('edit')
  end

  def sign_in
  end

  def sign_out
    session[:user_id] = nil
    redirect_to(root_url, :notice => 'Signed out!')
  end

  def do_sign_in
    user = User.find_by(:email => user_params['email'])
    if user && user.authenticate(user_params['password'])
      session[:user_id] = user.id
      redirect_to(root_url, :notice => 'Signed in!')
    else
      flash.now.alert = 'Email or password is incorrect'
      render('sign_in')
    end
  end

  def reset_password
    if params[:token]
      @user = User.find_by(:password_reset_token => params[:token])
    end
  end

  def send_reset_password
    user = User.find_by(:email => user_params['email'])
    user.update!(:password_reset_token => user.generate_token(false))
    UserMailer.reset_password(user).deliver_now
  end

  def do_reset_password
    user = User.find_by(:password_reset_token => params[:token])
    if user
      user.update!(:password => user_params['password'], :password_reset_token => nil)
      redirect_to(sign_in_users_path, :notice => 'Password changed')
    end
  rescue
    flash.now.alert = 'Password was not changed'
    render('reset_password')
  end

  private

    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation, :driver_ids => [])
    end

    def filter_token
      params[:token] = params[:token].gsub(/[^a-z0-9]/, '')[0..63] if params[:token]
    end

end
