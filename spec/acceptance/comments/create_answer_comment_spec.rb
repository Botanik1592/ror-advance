require_relative '../acceptance_helper'

feature 'Create comment', %q{
  User can leave a comment
} do
  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user) }

  scenario 'Authenticated user leave comment for an answer', js: true do
    sign_in(user)
    visit question_path(question)

    within "#answer-#{answer.id}-comments" do
      fill_in "new-comment-body-#{answer.id}", with: 'This is test comment'
      click_on 'Save'
    end

    expect(page).to have_content 'This is test comment'
  end

  scenario 'Authenticated user leave invalid comment for an answer', js: true do
    sign_in(user)
    visit question_path(question)

    within "#answer-#{answer.id}-comments" do
      fill_in "new-comment-body-#{answer.id}", with: 'T1'
      click_on 'Save'
    end

    expect(page).to_not have_content 'T1'
    expect(page).to have_content 'Body is too short (minimum is 3 characters)'
  end

  scenario 'Non-authenticated user dont see comment button and field', js: true do
    visit question_path(question)

    within "#answer-#{answer.id}-comments" do
      expect(page).to_not have_link 'Save'
      expect(page).to_not have_css 'input[type="text"]'
    end
  end

  scenario 'Created comment broadcasts to all users without page reloading', js: true do
    Capybara.using_session('user') do
      sign_in(user)
      visit question_path(question)
    end

    Capybara.using_session('guest') do
      visit question_path(question)
    end

    Capybara.using_session('user') do
      within "#answer-#{answer.id}-comments" do
        fill_in "new-comment-body-#{answer.id}", with: 'This is test comment'
        click_on 'Save'
      end

      expect(page).to have_content 'This is test comment'
    end

    Capybara.using_session('guest') do
      expect(page).to have_content 'This is test comment'
    end
  end
end
