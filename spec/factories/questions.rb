FactoryGirl.define do
  sequence :title do |n|
    "ThisIsMyTitle_#{n}"
  end

  sequence :body do |m|
    "ThisIsMyBody_#{m}"
  end

  factory :question do
    title "ThisIsMyString"
    body "ThisIsMyText"
    user
  end

  factory :question_list, class: "Question" do
    title
    body
    user
  end

  factory :invalid_question, class: "Question" do
    title nil
    body nil
    user
  end
end
