FactoryGirl.define do
  factory :question_attachment, class: Attachment do
    association :attachmentable, factory: :question
    file { Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec', 'rails_helper.rb')) }
  end

  factory :answer_attachment, class: Attachment do
    association :attachmentable, factory: :answer
    file { Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec', 'rails_helper.rb')) }
  end
end
