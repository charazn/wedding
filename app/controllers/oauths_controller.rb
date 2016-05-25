class OauthsController < ApplicationController
  skip_before_action :require_login

  def oauth
    login_at(auth_params[:provider])
  end

  def callback
    provider = auth_params[:provider]
    if params["error"]
      redirect_to login_path, :alert => "Failed to login from #{provider.titleize}! Error: #{params["error"].humanize}. Reason: #{params["error_reason"].humanize}"
    else
      user_hash = sorcery_fetch_user_hash(provider)
      if @user = login_from(provider)
        redirect_to photos_path, :notice => "Logged in from #{provider.titleize}!"
      else
        begin
          if current_user
            current_user.authentications.create(provider: provider, uid: user_hash[:uid])
            redirect_to photos_path, :notice => "Logged in from #{provider.titleize}!"
          else
            if user_hash[:user_info]["email"]
              @user = User.create(username: user_hash[:user_info]["name"], email: user_hash[:user_info]["email"], password: "#{user_hash[:user_info]["name"].downcase.delete(' ')}facebook", password_confirmation: "#{user_hash[:user_info]["name"].downcase.delete(' ')}facebook")
              @user.authentications.create(provider: provider, uid: user_hash[:uid])
              reset_session
              auto_login(@user)
              redirect_to photos_path, :notice => "Logged in from #{provider.titleize}!"
            else
              @user = User.create(username: user_hash[:user_info]["name"],
                                  email: "#{user_hash[:user_info]["name"].downcase.delete(' ')}@facebook.com",
                                  password: "#{user_hash[:user_info]["name"].downcase.delete(' ')}facebook",
                                  password_confirmation: "#{user_hash[:user_info]["name"].downcase.delete(' ')}facebook"
                                 )
              @user.authentications.create(provider: provider, uid: user_hash[:uid])
              reset_session
              auto_login(@user)
              redirect_to photos_path, :notice => "Logged in from #{provider.titleize}!"
            end
          end
        rescue # => ex
          redirect_to login_path, :alert => "Failed to login from #{provider.titleize}!"
        end
      end
    end
  end

  private

  def auth_params
    params.permit(:code, :provider)
  end

end
