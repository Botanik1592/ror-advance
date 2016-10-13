require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question) { create(:question) }

  describe 'POST #create' do
    context 'with valid attributes' do
      let(:create_answer) {  post :create, question_id: question.id, answer: attributes_for(:answer) }

      it "saves new answer for question in DB" do
        expect { create_answer }.to change(question.answers, :count).by(1)
      end

      it "redirect to question" do
        create_answer
        expect(response).to redirect_to question_path(question)
      end
    end

    context 'with invalid attributes' do
      let(:create_invalid_answer) { post :create, question_id: question.id, answer: attributes_for(:invalid_answer) }

      it "does not save answer for question in DB" do
        expect { create_invalid_answer }.to_not change(question.answers, :count)
      end

      it "redirect to new view" do
        create_invalid_answer
        expect(response).to redirect_to question_path(question)
      end
    end
  end

end
