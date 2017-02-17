require 'rails_helper'

feature 'Signing in using oauth', %q{
  User want be able to sign in using social networks
 } do

  background { visit new_user_session_path }

  scenario "Facebook user tries to sign in" do
    mock_auth_facebook
    click_link 'Sign in with Facebook'
    expect(page).to have_content('Successfully authenticated from Facebook account')
  end

  scenario "Facebook user tries to sign in with invalid credentials" do
    mock_auth_facebook_invalid
    click_link 'Sign in with Facebook'
    expect(page).to have_content('Could not authenticate you from Facebook because "Credentials are invalid"')
  end

  scenario "Vkontakte user tries to sign in" do
    mock_auth_vkontakte
    click_link 'Sign in with Vkontakte'
    expect(page).to have_content('Successfully authenticated from Vkontakte account')
  end

  scenario "Vkontakte user tries to sign in with invalid credentials" do
    mock_auth_vkontakte_invalid
    click_link 'Sign in with Vkontakte'
    expect(page).to have_content('Could not authenticate you from Vkontakte because "Credentials are invalid"')
  end

  scenario "Twitter user tries to sign in" do
    mock_auth_twitter
    click_link 'Sign in with Twitter'
    expect(page).to have_content('Successfully authenticated from Twitter account')
  end

  scenario "Twitter user tries to sign in with invalid credentials" do
    mock_auth_twitter_invalid
    click_link 'Sign in with Twitter'
    expect(page).to have_content('Could not authenticate you from Twitter because "Credentials are invalid"')
  end

  scenario "User tries to sign in without email" do
    mock_auth_without_email
    clear_emails
    click_link 'Sign in with Vkontakte'

    fill_in 'email', with: 'user@testemail.com'
    click_button 'Save'
    expect(page).to have_content "Could not authenticate you from Vkontakte because"

    open_email('user@testemail.com')
    current_email.click_link 'Confirm my account'

    expect(page).to have_content 'Your email address has been successfully confirmed'

    visit new_user_session_path
    click_link 'Sign in with Vkontakte'
    expect(page).to have_content 'Successfully authenticated from Vkontakte account'
  end
end
