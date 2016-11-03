require_relative 'acceptance_helper'

feature 'Add files to answer', %q{
  In order to illustrate my answer
  As an answer author
  I'd like to attache files
} do

  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }

  background do
    sign_in(user)
    visit question_path(question)
  end

  scenario "User add file when give answer", js: true do
    fill_in 'new-answer-body', with: 'test_test_test'

    within all('.nested-form').last do
      attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
    end

    click_on 'Add file'

    within all('.nested-form').first do
      attach_file 'File', "#{Rails.root}/spec/rails_helper.rb"
    end

    click_on 'Create answer'

    within '.one-answer' do
      expect(page).to have_link "spec_helper.rb", href: "/uploads/attachment/file/2/spec_helper.rb"
      expect(page).to have_link "rails_helper.rb", href: "/uploads/attachment/file/1/rails_helper.rb"
    end
  end
end
