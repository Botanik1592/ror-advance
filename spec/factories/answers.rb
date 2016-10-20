FactoryGirl.define do
  factory :answer do
    body "ThisIsMyAnswer"
    user
  end

  factory :invalid_answer, class: "Answer" do
    body nil
    user
  end
end
