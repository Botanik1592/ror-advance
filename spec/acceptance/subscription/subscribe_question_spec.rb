require_relative '../acceptance_helper'

feature 'Subscribe question', %q{
  In order to receive new answers by email
  As Authenticated User
  I want to be able to subscribe the question
} do
  let(:question) { create(:question) }
  let(:user) { create(:user) }

  scenario 'Non-authenticated user tries to subscribe or unsubscribe' do
    visit question_path(question)

    expect(page).to_not have_link 'Subscribe'
    expect(page).to_not have_link 'Unsubscribe'
  end

  context 'Authenticated user' do
    before do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'Subscribed user sees subscribe link' do
      create(:subscription, user_id: user.id, question_id: question.id)
      expect(page).to_not have_link 'Subscribe'
    end

    scenario 'Unsubscribed user sees unsubscribe link' do
      expect(page).to_not have_link 'Unubscribe'
    end
  end
end
