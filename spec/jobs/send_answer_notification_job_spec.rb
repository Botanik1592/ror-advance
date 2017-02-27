require 'rails_helper'

RSpec.describe SendAnswerNotificationJob, type: :job do
  let(:question) { create(:question) }
  let(:answer) { create(:answer, question: question) }
  let(:users) { create_list(:user, 3) }
  before do
    question.subscribers << users
  end

  it 'should mail answer to users' do
    question.subscribers.find_each.each do |user|
      expect(AnswerMailer).to receive(:notification).with(user, answer).and_call_original
    end

    SendAnswerNotificationJob.new.perform(answer)
  end
end
