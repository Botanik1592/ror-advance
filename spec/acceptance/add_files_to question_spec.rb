require_relative 'acceptance_helper'

feature 'Add files to question', %q{
  In order to illustrate my question
  As an question author
  I'd like to attache files
} do

  given(:user) { create(:user) }

  background do
    sign_in(user)
    visit new_question_path
  end

  scenario "User add file when asks question" do
    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'test_test_test'
    attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
    click_on 'Ask'

    expect(page).to have_link "spec_helper.rb", href: "/uploads/attachment/file/1/spec_helper.rb"
  end
end
