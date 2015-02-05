class SayWhat::UsersController < ApplicationController

  before_filter :find_user, :only => [ :show, :edit, :update, :destroy ]

  def index
    @users = User.order(:email)
  end

  def show
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    @user.save!
    redirect_to(say_what_user_path(@user), :notice => 'User created!')
  rescue
    render('new')
  end

  def edit
  end

  def update
    @user.update!(user_params)
    redirect_to(edit_say_what_user_path(@user), :notice => 'User updated')
  rescue
    render('edit')
  end

  private

    def find_user
      @user = User.find(params[:id].to_i)
    end

    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation, :token, :driver_ids => [])
    end

end
