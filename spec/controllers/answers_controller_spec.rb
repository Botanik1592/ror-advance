require 'rails_helper'
require_relative 'concerns/rated_spec'

RSpec.describe AnswersController, type: :controller do

  it_behaves_like 'rated'

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
        expect { delete :destroy, params: { id: answer, question_id: question, format: :js } }.to change(question.answers, :count).by(-1)
      end

      it 'redirect to question path' do
        delete :destroy, params: { id: answer, format: :js }
        expect(response).to render_template :destroy
      end
    end

    context 'not-author delete question' do
      let(:user) { create(:user) }
      let(:question) { user.questions.create(title: 'This Is Question Title', body: 'This Is Question Body') }
      let(:answer) { question.answers.create(body: 'My answer body', user_id: user.id) }

      before { answer }

      it 'not-delete answer' do
        expect { delete :destroy, params: { id: answer }, format: :js }.to_not change(Answer, :count)
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

  describe 'PATCH #make_best' do
    let(:user)     { create(:user) }
    let(:question) { user.questions.create(title: 'This Is Question Title', body: 'This Is Question Body') }
    let!(:answer1)  { question.answers.create(body: 'My answer body 1', user: user) }
    let!(:answer2)  { question.answers.create(body: 'My answer body 2', user: user) }
    let!(:answer3)  { question.answers.create(body: 'My answer body 3', user: user) }

    context "question author" do
      before { sign_in question.user }

      it "assings the answer eq @answer" do
        patch :mark_best, params: { id: answer1.id, best: true, format: :js }
        expect(assigns(:answer)).to eq answer1
      end

      it "mark answer's 'best' attribute to be true" do
        patch :mark_best, params: { id: answer1.id, best: true, format: :js }
        answer1.reload
        expect(answer1).to be_best
      end

      it "render best template" do
        patch :mark_best, params: { id: answer1.id, best: true, format: :js }
        expect(response).to render_template :mark_best
      end
    end

    context 'not question author try mark best answer' do
      sign_in_user

      it 'does not answer mark best' do
        patch :mark_best, params: { id: answer1.id, best: true, format: :js }
        expect(assigns(:answer).best?).not_to eq (true)
      end
    end
  end
end
