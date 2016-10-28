require_relative 'acceptance_helper'

feature 'Mark best answer', %q{
  In order to mark best answer
  As an question author
  I'd like to choose the best answer to my question
} do

  given(:user)   { create(:user) }
  given(:bad_user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given!(:answer1) { create(:answer, question: question, body: 'This is first answer') }
  given!(:answer2) { create(:answer, best: true, question: question, body: 'This is second anwser') }
  given!(:answer3) { create(:answer, question: question, body: 'This is BEST anwser') }


  scenario "Question author mark best answer", js: true do
    sign_in(user)
    visit question_path(question)

    within "#answer-#{answer3.id}" do
      click_link 'Mark best'

      expect(page).to have_content 'Best answer!'
      expect(page).to have_content answer3.body
      expect(page).to have_content 'This is BEST anwser'
    end

    within "#answer-#{answer1.id}" do
      expect(page).to_not have_content 'Best answer!'
      expect(page).to_not have_content 'This is BEST anwser'
    end

    within "#answer-#{answer2.id}" do
      expect(page).to_not have_content 'Best answer!'
      expect(page).to_not have_content 'This is BEST anwser'
    end
  end

  scenario "Authenticated user try to mark best answer for foreign question", js: true do
    sign_in(bad_user)
    visit question_path(question)
    expect(page).to_not have_link 'Mark best'
  end

  scenario 'Non-authenticated user try mark best answer' do
    visit question_path(question)
    expect(page).to_not have_link 'Mark best'
  end
end
