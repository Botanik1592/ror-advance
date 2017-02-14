require_relative '../acceptance_helper'

feature 'Show questions list', %q{
  User can view questions list
} do

  given(:user) { create(:user) }

  scenario 'User can view question list' do
    create_list(:question_list, 2)

    visit questions_path

    expect(page).to have_content 'ThisIsMyTitle_1'
    expect(page).to have_content 'ThisIsMyBody_1'
    expect(page).to have_content 'ThisIsMyTitle_2'
    expect(page).to have_content 'ThisIsMyBody_2'
  end
end
