require 'rails_helper'
require_relative 'concerns/ratable_spec.rb'

RSpec.describe Answer, type: :model do
  it_behaves_like 'ratable'

  it { should validate_presence_of :body }
  it { should validate_length_of(:body).is_at_least(10) }
  it { should belong_to(:question) }
  it { should have_many(:attachments) }
  it { should have_many(:comments).dependent(:destroy) }
  it { should have_many(:ratings) }

  it { should accept_nested_attributes_for :attachments }
end
