require_relative '../acceptance_helper'

feature 'Question editing', %q{
  In order to fix mistake
  As an question author
  I'd like to be able to edit my questsion
} do

  given(:user) { create(:user) }
  given(:bad_user) { create(:user) }
  given!(:question) { create(:question, user: user) }

  scenario 'Non-authenticated user try to edit question', js: true do
    visit question_path(question)

    expect(page).to_not have_link 'Edit'
  end

  describe 'Authenticated user' do
    before do
      sign_in user
      visit question_path(question)
    end

    scenario 'Question author try to edit question', js: true do
      click_on 'Edit'
      fill_in 'Edit title:', with: 'Edited title'
      fill_in 'Edit question:', with: "Edited question body"
      click_on 'Save'

      expect(page).to_not have_content question.title
      expect(page).to_not have_content question.body
      expect(page).to have_content 'Edited title'
      expect(page).to have_content 'Edited question body'
      expect(page).not_to have_content 'Edit title:'
      expect(page).not_to have_content 'Edit question:'
      expect(page).not_to have_content 'Save:'
    end

    scenario 'Question author see link to edit', js: true do
      expect(page).to have_link "Edit"
    end
  end
  scenario 'Authenticated user try to edit foreign question', js: true do
    sign_in bad_user
    visit question_path(question)

    expect(page).to_not have_link 'Edit'
  end
end
