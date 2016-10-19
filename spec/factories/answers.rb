FactoryGirl.define do
  factory :answer do
    body "ThisIsMyText"
    user
  end

  factory :invalid_answer, class: "Answer" do
    body nil
    user
  end
end
