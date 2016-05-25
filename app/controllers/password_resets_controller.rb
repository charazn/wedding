class PasswordResetsController < ApplicationController
  skip_before_action :require_login

  def new
  end

  def create
    @user = User.find_by_email(params[:user][:email])

    if @user
      @user.deliver_reset_password_instructions!
      redirect_to login_path, notice: 'Instructions on resetting your password have been sent to your email.'
    else
      flash[:error] = 'Email cannot be found.'
      redirect_to new_password_reset_path
    end
  end

  def edit
    @token = params[:id]
    @user = User.load_from_reset_password_token(params[:id])

    if @user.blank?
      not_authenticated
      return
    end
  end

  def update
    @token = params[:id]
    @user = User.load_from_reset_password_token(params[:id])

    if @user.blank?
      not_authenticated
      return
    end

    @user.password_confirmation = params[:user][:password_confirmation]

    if @user.change_password!(params[:user][:password])
      redirect_to(login_path, notice: 'Password was successfully updated.')
    else
      render :edit
    end
  end
end
