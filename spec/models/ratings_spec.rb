require 'rails_helper'

RSpec.describe Rating, type: :model do
  it { should belong_to(:ratable) }
  it { should belong_to(:user) }

  it { should validate_inclusion_of(:ratings).in_array [-1, 1] }
  it do
    subject.user = build(:user)
    should validate_uniqueness_of(:user_id).scoped_to(:ratable_id)
  end
end
