require 'rails_helper'

feature 'User sign out', %q{
  Authenticated user can sign out
} do

  given(:user) { create(:user) }

  scenario 'Authenticated user try to sign out' do
    sign_in(user)

    visit root_path
    click_on 'Sign out'

    expect(page).to have_content 'Signed out successfully.'
  end
end
