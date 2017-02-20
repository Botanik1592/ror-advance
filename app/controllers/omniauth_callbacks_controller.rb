class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  before_action :oauth_sign_in, only: [:facebook, :twitter, :vkontakte]

  def facebook
  end

  def vkontakte
  end

  def twitter
  end

  def email
    if params[:email].empty?
      render template: 'user/email'
      set_flash_message(:error, :email_empty) if is_navigational_format?
    else
      session[:email] = params[:email]
      social_auth(session)
    end
  end

  private

  def oauth_sign_in
    oauth = request.env['omniauth.auth']
    session[:uid] = oauth[:uid]
    session[:provider] = oauth.provider
    session[:email] = oauth.info[:email]

    authorization = User.find_for_authorization(session)

    if oauth.info[:email] || authorization
      social_auth(session)
    else
      session[:confirmation] = true
      render template: 'user/email'
    end
  end

  def social_auth(auth)
    @user = User.find_for_oauth(auth)
    if @user
      if @user.confirmed?
        sign_in_and_redirect @user, event: :authentication
        set_flash_message(:notice, :success, kind: auth[:provider].capitalize) if is_navigational_format?
      else
        redirect_to root_path
        set_flash_message(:notice, :failure, kind: auth[:provider].capitalize, reason: 'you need to confirm email address first') if is_navigational_format?
      end
    else
      redirect_to root_path
      set_flash_message(:error, :cant_authorize) if is_navigational_format?
    end
  end
end
