require 'rails_helper'

RSpec.describe Ability do
  subject(:ability) { Ability.new(user) }

  describe 'for guest' do
    let(:user) { nil }

    it { should be_able_to :read, Question }
    it { should be_able_to :read, Answer }
    it { should be_able_to :read, Comment }

    it { should_not be_able_to :manage, :all }
  end

  describe 'for admin' do
    let(:user) { create(:user, admin: true) }

    it { should be_able_to :manage, :all }
  end

  describe 'for user' do
    let(:user)                { create(:user) }
    let(:other_user)          { create(:user) }
    let(:user_question)       { create(:question, user: user) }
    let(:other_user_question) { create(:question, user: other_user) }
    let(:user_answer)         { create(:answer, user: user) }
    let(:other_user_answer)   { create(:answer, user: other_user) }

    it { should be_able_to :read, :all }
    it { should_not be_able_to :manage, :all }

    it { should be_able_to :create, Question }
    it { should be_able_to :create, Answer }
    it { should be_able_to :create, Comment }

    it { should be_able_to :update, user_question }
    it { should_not be_able_to :update, other_user_question }
    it { should be_able_to :update, user_answer }
    it { should_not be_able_to :update, other_user_answer }

    it { should be_able_to :destroy, user_question }
    it { should_not be_able_to :destroy, other_user_question }
    it { should be_able_to :destroy, user_answer }
    it { should_not be_able_to :destroy, other_user_answer }

    it { should be_able_to :rate_up, other_user_question }
    it { should_not be_able_to :rate_up, user_question }
    it { should be_able_to :rate_down, other_user_question }
    it { should_not be_able_to :rate_down, user_question }

    it { should be_able_to :rate_up, create(:answer) }
    it { should_not be_able_to :rate_up, user_answer }
    it { should be_able_to :rate_down, create(:answer) }
    it { should_not be_able_to :rate_down, user_answer }

    it { should be_able_to :destroy, user_question.attachments.build }
    it { should_not be_able_to :destroy, other_user_question.attachments.build }

    it { should be_able_to :mark_best, create(:answer, question: user_question) }
    it { should_not be_able_to :mark_best, create(:answer, question: other_user_question) }
  end
end
