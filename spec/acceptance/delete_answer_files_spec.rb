require_relative 'acceptance_helper'

feature 'Remove files from answer', %q{
  In order to delete files from my answer
  As an answer author
  I'd like to remove attache file
} do

  given(:user)   { create(:user) }
  given(:bad_user) { create(:user) }
  given(:question) { create(:question, user: user) }

  background do
    sign_in(user)
    visit question_path(question)
    fill_in 'new-answer-body', with: 'Test test test answer'
    attach_file 'File', "#{Rails.root}/spec/rails_helper.rb"
    click_on 'Create answer'
  end

  scenario "User delete file from his answer", js: true do
    within '.attachments_answer_files' do
      click_on 'X'
    end
    expect(page).to_not have_link 'rails_helper.rb', href: '/uploads/attachment/file/1/rails_helper.rb'
  end

  scenario "Non author of answer try to delete file from answer", js: true do
    logoff
    sign_in(bad_user)
    visit question_path(question)

    within '.attachments_answer_files' do
      expect(page).to_not have_link 'X'
    end
  end
end
