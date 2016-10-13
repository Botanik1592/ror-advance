FactoryGirl.define do
  factory :answer do
    body "ThisIsMyText"
  end

  factory :invalid_answer, class: "Answer" do
    body nil
  end
end
