require 'rails_helper'

feature 'Create question', %q{
  In order to get answer from community
  As an authenticated user
  I want to be able to ask questions
} do

  given(:user) { create(:user) }

  scenario 'Authenticated user create question' do
    sign_in(user)

    visit questions_path
    click_on 'New question'
    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'test_test_test'
    click_on 'Ask'

    expect(page).to have_content 'Question successfully created'
    expect(page).to have_content 'Test question'
    expect(page).to have_content 'test_test_test'
  end

  scenario 'Non-authenticated user create question' do
    visit questions_path
    click_on 'New question'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end

end
