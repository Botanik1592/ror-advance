FactoryGirl.define do
  factory :question do
    title "ThisIsMyString"
    body "ThisIsMyText"
  end

  factory :invalid_question, class: "Question" do
    title nil
    body nil
  end
end
