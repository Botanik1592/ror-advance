FactoryGirl.define do
  factory :answer do
    sequence(:body) { |n| "ThisIsMyAnswer#{n}" }
    user
    question
  end

  factory :invalid_answer, class: "Answer" do
    body nil
    user
  end
end
