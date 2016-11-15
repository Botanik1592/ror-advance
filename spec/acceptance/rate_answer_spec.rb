require_relative 'acceptance_helper'

feature 'Rate answer', %q{
  To maintain the desired response
  As an authenticated user
  I want to be able to vote for answer
} do

  given(:user) { create(:user) }
  given(:user2) { create(:user) }

  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question, user: user2) }

  given!(:answer2) { create(:answer, question: question, user: user2) }

  scenario 'User rate up the answer', js: true do
    sign_in(user)
    visit question_path(question)

    click_on("answer-rateup-#{answer.id}")

    within "#answer-rating-#{answer.id}" do
      expect(page).to have_text('1')
    end
  end

  scenario 'User rate down the answer', js: true do
    sign_in(user)
    visit question_path(question)

    click_on("answer-ratedown-#{answer.id}")

    within "#answer-rating-#{answer.id}" do
      expect(page).to have_text('-1')
    end
  end

  scenario 'User rate down and after rate up the answer', js: true do
    sign_in(user)
    visit question_path(question)

    click_on("answer-ratedown-#{answer.id}")

    sleep 0.1

    click_on("answer-rateup-#{answer.id}")

    within "#answer-rating-#{answer.id}" do
      expect(page).to have_text('1')
    end
  end

  scenario 'User tries to rate his answer', js: true do
    sign_in(user2)
    visit question_path(question)

    expect(page).to_not have_link "answer-rateup-#{answer2.id}"
    expect(page).to_not have_link "answer-ratedown-#{answer2.id}"
  end

  scenario 'Non-authenticated user tries to rate answer', js: true do
    visit question_path(question)

    expect(page).to_not have_link "answer-rateup-#{answer.id}"
    expect(page).to_not have_link "answer-ratedown-#{answer.id}"
  end
end
