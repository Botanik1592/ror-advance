require 'rails_helper'

RSpec.describe User do
  it { should validate_presence_of :email }
  it { should validate_presence_of :password }
  it { should have_many(:questions) }
  it { should have_many(:answers) }

  it 'user author of question' do
    user = create(:user)
    question = create(:question, user: user)
    expect(user).to be_author_of(question)
  end

  it 'user author of answer' do
    user = create(:user)
    question = create(:question, user: user)
    answer = create(:answer, question: question, user: user)
    expect(user).to be_author_of(answer)
  end
end
