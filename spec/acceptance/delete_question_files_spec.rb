require_relative 'acceptance_helper'

feature 'Remove files from question', %q{
  In order to delete files from my question
  As an question author
  I'd like to remove attache file
} do

  given(:user)   { create(:user) }
  given(:bad_user) { create(:user) }

  background do
    sign_in(user)
    visit new_question_path
    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'test_test_test'
    attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
    click_on 'Ask'
  end

  scenario 'User delete file from his question', js: true do

    within '.attachments_question_files' do
      click_on 'X'
    end
    expect(page).to_not have_link 'spec_helper.rb', href: '/uploads/attachment/file/1/spec_helper.rb'
  end

  scenario "User tries to delete file attached to other user's question", js: true do
    logoff
    sign_in(bad_user)
    visit '/questions/1'

    within '.attachments_question_files' do
      expect(page).to_not have_link 'X'
    end
  end
end
