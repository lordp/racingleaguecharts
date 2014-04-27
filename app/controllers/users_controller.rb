class UsersController < ApplicationController

  before_filter :authorize, :only => [ :edit, :update ]

  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      redirect_to(root_url, :notice => 'Signed up!')
    else
      render('new')
    end
  end

  def edit
    @user = current_user
  end

  def update
    @user = current_user
    if @user.update_attributes(params[:user])
      redirect_to(edit_user_path(@user), :notice => 'User details updated')
    else
      render('edit')
    end
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

end
