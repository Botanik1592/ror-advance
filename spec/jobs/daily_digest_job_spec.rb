require 'rails_helper'

RSpec.describe DailyDigestJob, type: :job do

  it 'sends daily digest' do
    User.find_each.each do
      expect(DailyMailer).to receive(:digest).with(user).and_call_original
    end
    DailyDigestJob.perform_now
  end
end
