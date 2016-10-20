require 'rails_helper'

feature 'User delete answer', %q{
  User delete answer
} do

  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }

  scenario 'Authenticated user try delete his answer' do
    sign_in(user)

    answer = create(:answer, user: user, question: question)

    visit question_path(question)
    click_on 'Delete answer'

    expect(page).to have_content 'Answer successfully deleted.'
    expect(page).to_not have_content answer.body
  end

  scenario 'Authenticated user tries to remove a foreign answer' do
    user2 = create(:user)
    question2 = create(:question, user: user2)

    sign_in(user)

    visit question_path(question2)
    expect(page).to_not have_content 'Delete answer'
  end
end
