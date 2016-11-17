require_relative 'acceptance_helper'

feature 'Rate question', %q{
  To maintain the desired author
  As an authenticated user
  I want to be able to vote for question
} do

  given(:user) { create(:user) }
  given(:user2) { create(:user) }

  given!(:question) { create(:question, user: user) }
  given!(:question2) { create(:question, user: user2) }

  scenario 'User rate up the question', js: true do
    sign_in(user)
    visit questions_path

    click_on("question-rateup-#{question2.id}")

    within "#question-rating-#{question2.id}" do
      expect(page).to have_text('1')
    end
  end

  scenario 'User rate down the question', js: true do
    sign_in(user)
    visit questions_path

    click_on("question-ratedown-#{question2.id}")

    within "#question-rating-#{question2.id}" do
      expect(page).to have_text('-1')
    end
  end

  scenario 'User rate down and after rate up the question', js: true do
    sign_in(user)
    visit questions_path

    click_on("question-ratedown-#{question2.id}")

    sleep 0.1

    click_on("question-rateup-#{question2.id}")

    within "#question-rating-#{question2.id}" do
      expect(page).to have_text('1')
    end
  end

  scenario 'User tries to rate his question', js: true do
    sign_in(user)
    visit questions_path

    expect(page).to_not have_link "question-rateup-#{question.id}"
    expect(page).to_not have_link "question-ratedown-#{question.id}"
  end

  scenario 'Non-authenticated user tries to rate question', js: true do
    visit question_path(question)

    expect(page).to_not have_link "question-rateup-#{question.id}"
    expect(page).to_not have_link "question-ratedown-#{question.id}"
  end
end
