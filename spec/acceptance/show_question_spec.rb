require_relative 'acceptance_helper'

feature 'Show question', %q{
  User can view question and answers
} do

  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }

  scenario 'User can click Show link and view question with answers' do
    create_list(:answer, 2, question: question)

    visit questions_path
    click_on 'Show question'

    expect(page).to have_content 'ThisIsMyString'
    expect(page).to have_content 'ThisIsMyText'
    expect(page).to have_content 'ThisIsMyAnswer2'
    expect(page).to have_content 'ThisIsMyAnswer3'

  end
end
