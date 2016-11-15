require_relative 'acceptance_helper'

feature 'Create question', %q{
  In order to get answer from community
  As an authenticated user
  I want to be able to ask questions
} do

  given(:user) { create(:user) }

  scenario 'Authenticated user create question with valid data' do
    sign_in(user)

    visit questions_path
    click_on 'Ask question'
    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'test_test_test'
    click_on 'Ask'

    expect(page).to have_content 'Question successfully created'
    expect(page).to have_content 'Test question'
    expect(page).to have_content 'test_test_test'
  end

  scenario 'Authenticated user create question with invalid data' do
    sign_in(user)

    visit questions_path
    click_on 'Ask question'
    click_on 'Ask'

    expect(page).to have_content 'Title is too short (minimum is 10 characters)'
    expect(page).to have_content "Title can't be blank"
    expect(page).to have_content "Body can't be blank"
    expect(page).to have_content "Body is too short (minimum is 10 characters)"
  end

  scenario 'Non-authenticated user create question' do
    visit questions_path
    click_on 'Ask question'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end

end
