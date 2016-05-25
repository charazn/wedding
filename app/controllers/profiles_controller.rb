class ProfilesController < ApplicationController
  before_action :set_user

  def edit
  end

  def update
    if @user.update(user_params)
      redirect_to photos_path, notice: 'Your profile has been updated.'
    else
      render :edit
    end
  end

  private

  def set_user
    @user = current_user
  end

  def user_params
    params.require(:user).permit(:email, :mobile, :username, :password, :password_confirmation, :image)
  end
end
