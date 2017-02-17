class User < ApplicationRecord

  has_many :questions
  has_many :answers
  has_many :ratings
  has_many :comments
  has_many :authorizations

  validates :email, format: /@/

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable, :recoverable, :rememberable, :trackable, :validatable, :omniauthable, omniauth_providers: [:facebook, :twitter, :vkontakte]

  def author_of?(res)
    res.user_id == id
  end

  def self.find_for_oauth(auth)
    authorization = Authorization.where(provider: auth[:provider], uid: auth[:uid].to_s).first
    return authorization.user if authorization

    email = auth[:email]
    user = User.where(email: email).first

    unless user
      password = Devise.friendly_token[0, 20]
      if auth[:confirmation] == true
        user = User.new(email: email, password: password, password_confirmation: password)
        user.save
      else
        user = User.new(email: email, password: password, password_confirmation: password)
        user.skip_confirmation!
        user.save
      end
    end
    user.create_authorization(auth)
    user
  end

  def self.get_hash(pre_auth)
    auth = {}
    if pre_auth.info[:email] == nil
      auth[:email] = nil
      auth[:confirmation] = true
    else
      auth[:email] = pre_auth.info[:email]
      auth[:confirmation] = false
    end
    auth[:provider] = pre_auth.provider
    auth[:uid] = pre_auth.uid
    return auth
  end

  def create_authorization(auth)
     self.authorizations.create!(provider: auth[:provider], uid: auth[:uid])
  end
end
