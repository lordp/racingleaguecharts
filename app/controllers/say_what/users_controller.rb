class SayWhat::UsersController < ApplicationController

  def index
    @users = User.order(:email)
  end

  def show
    @user = User.find(params[:id].to_i)
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      redirect_to(say_what_user_path(@user), :notice => 'User created!')
    else
      render('new')
    end
  end

  def edit
    @user = User.find(params[:id].to_i)
  end

  def update
    @user = User.find(params[:id].to_i)
    if @user.update_attributes(params[:user])
      redirect_to(edit_say_what_user_path(@user), :notice => 'User updated')
    else
      render('edit')
    end
  end

end
