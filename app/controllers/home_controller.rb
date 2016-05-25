class HomeController < ApplicationController
  skip_before_action :require_login, except: [:thank_you]

  def index
    @user = User.new
  end

  def send_invitation_card
    email = params[:user][:email]
    InvitationCardMailer.invitation_card(email).deliver_now
    flash[:signed_up_for_invitation_card] = "Thank you #{email}. The invitation card has been sent to your email."
    redirect_to root_path
  end

  def thank_you
  end

  private

  def user_params
    params.require(:user).permit(:email, :mobile, :username, :password, :password_confirmation)
  end

end
