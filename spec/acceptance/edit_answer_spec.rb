require_relative 'acceptance_helper'

feature 'Answer editing', %q{
  In order to fix mistake
  As an answer author
  I'd like to be able to edit my answer
} do

  given(:user) { create(:user) }
  given(:bad_user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user) }

  scenario 'Non-authenticated user try to edit answer', js: true do
    visit question_path(question)

    expect(page).to_not have_link 'Edit'
  end

  describe 'Authenticated user' do
    before do
      sign_in user
      visit question_path(question)
    end

    scenario 'Answer author try to edit answer', js: true do
      click_on 'Edit answer'
      fill_in 'Edit answer:', with: 'Edited answer', match: :first
      click_on 'Save'

      within '.one-answer' do
        expect(page).to_not have_content answer.body
        expect(page).to have_content 'Edited answer'
        expect(page).not_to have_selector('textarea')
      end
    end

    scenario 'Answer author see link to edit', js: true do
      within '.one-answer' do
        expect(page).to have_link "Edit"
      end
    end
  end
  scenario 'Authenticated user try to edit foreign answer', js: true do
    sign_in bad_user
    visit question_path(question)

    expect(page).to_not have_link 'Edit'
  end
end
