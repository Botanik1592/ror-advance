require_relative '../acceptance_helper'

feature 'User delete question', %q{
  User delete question
} do

  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }

  scenario 'Authenticated user try delete his question' do

    sign_in(user)

    visit question_path(question)
    click_on 'Delete question'

    expect(page).to have_content 'Question successfully deleted.'
    expect(page).to_not have_content question.title
  end

  scenario 'Authenticated user tries to remove a foreign question' do

    user2 = create(:user)
    question2 = create(:question, user: user2)

    sign_in(user)

    visit question_path(question2)
    expect(page).to_not have_content 'Delete question'
  end

  scenario 'Non-authenticated user tries to remove question' do
    visit question_path(question)
    expect(page).to_not have_content 'Delete question'
  end
end
