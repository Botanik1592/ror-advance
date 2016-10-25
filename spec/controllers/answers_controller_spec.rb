require 'rails_helper'

RSpec.describe AnswersController, type: :controller do

  describe 'POST #create' do
    let(:question) { create(:question, user: @user) }
    sign_in_user

    context 'with valid attributes' do
      let(:create_answer) { post :create, params: { question_id: question.id, format: :js, answer: attributes_for(:answer) } }

      it "saves new answer for question in DB" do
        expect { create_answer }.to change(question.answers.where(user: @user), :count).by(1)
      end

      it "redirect to question" do
        create_answer
        expect(response).to render_template :create
      end
    end

    context 'with invalid attributes' do
      let(:create_invalid_answer) { post :create, params: { question_id: question.id, format: :js, answer: attributes_for(:invalid_answer) } }

      it "does not save answer for question in DB" do
        expect { create_invalid_answer }.to_not change(Answer, :count)
      end

      it "render answer create template" do
        create_invalid_answer
        expect(response).to render_template :create
      end

    end
  end

  describe 'DELETE #destroy' do
    sign_in_user

    context 'autor delete his answer' do
      let(:question) { @user.questions.create(title: 'ThisIsMyString', body: 'ThisIsMyText') }
      let(:answer) { question.answers.create(body: 'My answer body', user_id: @user.id) }

      before { answer }

      it 'delete answer' do
        expect { delete :destroy, params: { id: answer, question_id: question } }.to change(question.answers, :count).by(-1)
      end

      it 'redirect to question path' do
        delete :destroy, params: { id: answer }
        expect(response).to redirect_to question
      end
    end

    context 'not-author delete question' do
      let(:user) { create(:user) }
      let(:question) { user.questions.create(title: 'This Is Question Title', body: 'This Is Question Body') }
      let(:answer) { question.answers.create(body: 'My answer body', user_id: user.id) }

      before { answer }

      it 'not-delete answer' do
        expect { delete :destroy, params: { id: answer } }.to_not change(Answer, :count)
      end
    end
  end

  describe 'PATCH #update' do
    sign_in_user

    let(:question) { @user.questions.create(title: 'This Is Question Title', body: 'This Is Question Body') }
    let(:answer) { question.answers.create(body: 'My answer body', user_id: @user.id) }
    let(:answer_params) do {
      id: answer,
      question_id: question.id,
      answer: { body: 'New answer body' }
      }
    end

    it 'assings the requested answer to @answer' do
      patch :update, params: answer_params, format: :js
      expect(assigns(:answer)).to eq answer
    end

    it 'changes answer attributes' do
      patch :update, params: answer_params, format: :js
      answer.reload
      expect(answer.body).to eq 'New answer body'
    end

    it 'render update template' do
      patch :update, params: answer_params, format: :js
      expect(response).to render_template :update
    end
  end
end
