class User < ApplicationRecord

  has_many :questions
  has_many :answers
  has_many :ratings
  has_many :comments
  has_many :authorizations

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable, :recoverable,
         :rememberable, :trackable, :validatable, :omniauthable,
         omniauth_providers: [:facebook, :twitter, :vkontakte]

  def author_of?(res)
    res.user_id == id
  end

  def self.find_for_oauth(auth)
    authorization = User.find_for_authorization(auth)
    return authorization.user if authorization

    email = auth[:email]
    user = User.where(email: email).first

    unless user
      password = Devise.friendly_token[0, 20]
      if auth[:confirmation]
        user = create!(email: email, password: password, password_confirmation: password)
      else
        user = User.new(email: email, password: password, password_confirmation: password)
        user.skip_confirmation!
        user.save
      end
    end
    user.create_authorization(auth)
    user
  end

  def self.find_for_authorization(auth)
    Authorization.where(provider: auth[:provider], uid: auth[:uid].to_s).first
  end

  def create_authorization(auth)
     authorizations.create!(provider: auth[:provider], uid: auth[:uid])
  end
end
