require_relative '../acceptance_helper'
require_relative '../search_helper'

feature 'Search', %q{
  To be able to find information, anyone can use search
} do

  let!(:question1) { create(:question, title: 'Founded question 1')}
  let!(:question2) { create(:question, title: 'Founded question 2')}
  let!(:answer) { create(:answer, body: 'Founded answer')}
  let!(:comment1) { create(:question_comment, body: 'Founded question comment')}
  let!(:comment2) { create(:answer_comment, body: 'Founded answer comment')}
  let!(:user) { create(:user, email: 'founded@test.com')}

  let!(:not_findable) { create(:question, title: 'Tobeornottobe')}

  before do
    index
    visit root_path
  end

  scenario 'Empty query', js: true do
    click_button 'Submit'

    expect(page).to have_content('No results')

  end

  scenario 'Empty(All) contexts', js: true do
    fill_in 'Search', with: 'Founded'
    click_button 'Submit'

    expect(page).to have_content('Founded question 1')
    expect(page).to have_content('Founded question 2')
    expect(page).to have_content('Founded answer')
    expect(page).to have_content('Founded question comment')
    expect(page).to have_content('Founded answer comment')
    expect(page).to have_content('founded@test.com')
    expect(page).not_to have_content('Tobeornottobe')
  end

  scenario 'User searches questions', js: true do
    fill_in 'Search', with: 'Founded'
    select 'Questions', from: 'context'
    click_button 'Submit'

    expect(page).to have_content('Founded question 1')
    expect(page).to have_content('Founded question 2')
  end

  scenario 'User searches answers', js: true do
    fill_in 'Search', with: 'Founded'
    select 'Answers', from: 'context'
    click_button 'Submit'

    expect(page).to have_content('Founded answer')
  end

  scenario 'User searches comments', js: true do
    fill_in 'Search', with: 'Founded'
    select 'Comments', from: 'context'
    click_button 'Submit'

    expect(page).to have_content('Founded answer comment')
    expect(page).to have_content('Founded question comment')
  end

  scenario 'User searches users', js: true do
    fill_in 'Search', with: 'Founded'
    select 'Users', from: 'context'
    click_button 'Submit'

    expect(page).to have_content('founded@test.com')
  end
end
