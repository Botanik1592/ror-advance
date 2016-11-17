FactoryGirl.define do
  factory :rating do
    ratable { |v| v.association(:question) }
    user
    ratings 1
  end
end
