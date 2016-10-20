require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do

  let(:question) { create(:question) }

  describe 'GET #index' do
    let(:questions) { create_list(:question, 2) }
    before do
      get :index
    end

    it 'populates an array of all questions' do
      expect(assigns(:questions)).to match_array(questions)
    end

    it 'renders index view' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do

    before { get :show, params: { id: question } }

    it 'assings the requested question to @question' do
      expect(assigns(:question)).to eq question
    end

    it 'renders show view' do
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do
    sign_in_user

    before { get :new }

    it 'assings a new Question to @question' do
      expect(assigns(:question)).to be_a_new(Question)
    end

    it 'renders new view' do
      expect(response).to render_template :new
    end
  end

  describe 'GET #edit' do
    sign_in_user

    before { get :edit, params: { id: question } }

    it 'assings the requested question to @question' do
      expect(assigns(:question)).to eq question
    end

    it 'renders edit view' do
      expect(response).to render_template :edit
    end
  end

  describe 'POST #create' do
    sign_in_user

    context 'with valid attributes' do
      let(:create_question) { post :create, params: { question: attributes_for(:question) } }
      it 'saves the new question in the DB' do
        expect { create_question }.to change(@user.questions, :count).by(1)
      end
      it 'redirects the show view' do
        create_question
        expect(response).to redirect_to question_path(assigns(:question))
      end
    end

    context 'with invalid attributes' do
      let(:create_invalid_question) { post :create, params: { question: attributes_for(:invalid_question) } }
      it ' does not save the question' do
        expect { create_invalid_question }.to_not change(Question, :count)
      end

      it ' re-renders new view' do
        create_invalid_question
        expect(response).to render_template :new
      end
    end
  end

  describe 'DELETE #destroy' do
    sign_in_user

    context 'autor delete his question' do
      let(:question) { @user.questions.create(title: 'ThisIsMyString', body: 'ThisIsMyText') }
      before { question }

      it 'delete question' do
        expect { delete :destroy, params: { id: question } }.to change(Question, :count).by(-1)
      end

      it 'redirect to index view' do
        delete :destroy, params: { id: question }
        expect(response).to redirect_to questions_path
      end
    end

    context 'not-author delete question' do
      let(:question) { create(:user).questions.create(title: 'This Is Question Title', body: 'This Is Question Body') }
      before { question }

      it 'not-delete question' do
        expect { delete :destroy, params: { id: question } }.to_not change(Question, :count)
      end
    end
  end
end
