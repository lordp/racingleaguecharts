class UserMailer < ApplicationMailer
  default(:from => 'admin@racingleaguecharts.com')

  def reset_password(user)
    @user  = user
    @token = @user.password_reset_token

    mail(:to => @user.email, :subject => 'Password reset')
  end
end
