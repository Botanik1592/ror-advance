module OmniauthMacros
  def mock_auth_facebook
    OmniAuth.config.mock_auth[:facebook] = OmniAuth::AuthHash.new({
      provider: 'facebook',
      uid: '12345678',
      info: {
        email: 'user@example.com',
        name: 'Anton Buryka',
        image: 'http://facebot.ru/images/userdateimg/08_27/09eb14bfa44f75af65cdea0b05f0c0b3.jpg'
      }
    })
  end

  def mock_auth_vkontakte
    OmniAuth.config.mock_auth[:vkontakte] = OmniAuth::AuthHash.new({
      provider: 'vkontakte',
      uid: '12345678',
      info: {
        email: 'user@example.com',
        name: 'Anton Buryka',
        image: 'http://facebot.ru/images/userdateimg/08_27/09eb14bfa44f75af65cdea0b05f0c0b3.jpg'
      }
    })
  end

  def mock_auth_twitter
    OmniAuth.config.mock_auth[:twitter] = OmniAuth::AuthHash.new({
      provider: 'twitter',
      uid: '12345678',
      info: {
        email: 'user@example.com',
        name: 'Anton Buryka',
        image: 'http://facebot.ru/images/userdateimg/08_27/09eb14bfa44f75af65cdea0b05f0c0b3.jpg'
      }
    })
  end

  def mock_auth_without_email
    OmniAuth.config.mock_auth[:vkontakte] = OmniAuth::AuthHash.new({
      provider: 'vkontakte',
      uid: '12345678',
      info: {
        email: nil,
        name: 'Anton Buryka',
        image: 'http://facebot.ru/images/userdateimg/08_27/09eb14bfa44f75af65cdea0b05f0c0b3.jpg'
      }
    })
  end

  def mock_auth_facebook_invalid
    OmniAuth.config.mock_auth[:facebook] = :credentials_are_invalid
  end

  def mock_auth_vkontakte_invalid
    OmniAuth.config.mock_auth[:vkontakte]  = :credentials_are_invalid
  end

  def mock_auth_twitter_invalid
    OmniAuth.config.mock_auth[:twitter]  = :credentials_are_invalid
  end
end
