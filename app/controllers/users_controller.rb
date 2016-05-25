class UsersController < ApplicationController
  skip_before_action :require_login, only: [:new, :create]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    @user.location = params[:user][:location].to_i
    if @user.save
      auto_login(@user)
      InvitationCardMailer.invitation_card(@user).deliver_now
      flash[:signed_up_for_invitation_card] = "Thank you, #{current_user.username}, for signing up with us.
                                               The invitation card has been sent to your email."
      redirect_to root_path
    else
      render :new
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :mobile, :username, :password, :password_confirmation, :image, :location)
  end

end
