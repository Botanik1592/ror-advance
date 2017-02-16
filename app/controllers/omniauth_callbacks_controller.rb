class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  before_action :oauth_sign_in, only: [:facebook, :twitter, :vkontakte]

  def facebook
  end

  def vkontakte
  end

  def twitter
  end

  def email
    auth = {}
    auth[:email] = params[:email]
    auth[:confirmation] = true
    auth[:provider] = params[:provider]
    auth[:uid] = params[:uid]
    social_auth(auth)

  end

  def oauth_sign_in
    pre_auth = request.env['omniauth.auth']
    @auth = User.get_hash(pre_auth)

    authorization = Authorization.where(provider: @auth[:provider], uid: @auth[:uid].to_s).first

    if @auth[:confirmation] == true && authorization == nil
      render template: 'user/email'
    else
      social_auth(@auth)
    end
  end

  private

  def social_auth(auth)
    @user = User.find_for_oauth(auth)

    if @user.persisted?
      if @user.confirmed?
        sign_in_and_redirect @user, event: :authentication
        set_flash_message(:notice, :success, kind: auth[:provider].capitalize) if is_navigational_format?
      else
        redirect_to root_path
        set_flash_message(:notice, :failure, kind: auth[:provider].capitalize, reason: 'you need to confirm email address first') if is_navigational_format?
      end
    end
  end
end
