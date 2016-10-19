require 'rails_helper'

feature 'Create answer', %q{
  As an authenticated user
  I want to be able to get answers
} do

  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }

  scenario 'Authenticated user create answer' do
    sign_in(user)

    visit question_path(question)
    fill_in 'Body', with: 'Test test test answer'
    click_on 'Create answer'

    expect(page).to have_content 'Test test test answer'
  end

  scenario 'Non-authenticated user tries create answer' do

    visit question_path(question)
    expect(page).to have_content 'You must sign in first for create answer'
  end
end
