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

  scenario "User add file when asks question", js: true do
    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'test_test_test'

    within all('.nested-form').last do
      attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
    end

    click_on 'Add file'

    within all('.nested-form').first do
      attach_file 'File', "#{Rails.root}/spec/rails_helper.rb"
    end

    click_on 'Ask'

    expect(page).to have_link "spec_helper.rb", href: "/uploads/attachment/file/2/spec_helper.rb"
    expect(page).to have_link "rails_helper.rb", href: "/uploads/attachment/file/1/rails_helper.rb"
  end
end
