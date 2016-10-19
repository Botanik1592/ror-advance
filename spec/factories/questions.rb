FactoryGirl.define do
  factory :question do
    title "ThisIsMyString"
    body "ThisIsMyText"
    user
  end

  factory :invalid_question, class: "Question" do
    title nil
    body nil
    user
  end
end
