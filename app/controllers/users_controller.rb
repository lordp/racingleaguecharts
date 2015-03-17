class UsersController < ApplicationController

  before_filter :authorize, :only => [ :edit, :update ]

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
    user = User.find_by_email(params[:email])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to(root_url, :notice => 'Signed in!')
    else
      flash.now.alert = 'Email or password is incorrect'
      render('sign_in')
    end
  end

  private

    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation, :driver_ids => [])
    end

end
