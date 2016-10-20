require 'rails_helper'

feature 'User sign up', %q{
  In order to be able to sign in
  As an User
  I want to be able to sign up
} do

  scenario 'Non-registered user try to sign up with valid parameters' do
    visit new_user_registration_path

    fill_in 'Email', with: 'test@user.com'
    fill_in 'Password', with: '12345678'
    fill_in 'Password confirmation', with: '12345678'
    click_on 'Sign up'

    expect(page).to have_content 'Welcome! You have signed up successfully.'
  end

  scenario 'Non-registered user try to sign up with invalid parameters' do
    visit new_user_registration_path

    click_on 'Sign up'

    expect(page).to_not have_content 'Welcome! You have signed up successfully.'
  end
end
