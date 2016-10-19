require 'rails_helper'

feature 'Show questions list', %q{
  User can view questions list
} do

  given(:user) { create(:user) }

  scenario 'User can view question list' do
    5.times { create(:question, user: user) }

    visit questions_path

    expect(page).to have_content 'ThisIsMyString'
    expect(page).to have_content 'ThisIsMyText'
  end
end

feature 'Show question', %q{
  User can view question and answers
} do

  given(:user) { create(:user) }

  scenario 'User can click Show link and view question with answers' do
    create(:question, user: user)

    visit questions_path
    click_on 'Show question'

    expect(page).to have_content 'ThisIsMyString'
    expect(page).to have_content 'ThisIsMyText'

  end
end
