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

    it 'build new attachment for question' do
      expect(assigns(:question).attachments.first).to be_a_new(Attachment)
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

  describe 'PATCH #update' do
    sign_in_user

    context 'is author' do
      let(:question) { @user.questions.create(title: 'This Is Question Title', body: 'This Is Question Body') }
      let(:params) do {
        id: question,
        question: { title: 'New question title', body: 'New question body' }
        }
      end

      it 'assings the requested answer to @question' do
        patch :update, params: params, format: :js
        expect(assigns(:question)).to eq question
      end

      it 'changes answer attributes' do
        patch :update, params: params, format: :js
        question.reload
        expect(question.title).to eq 'New question title'
        expect(question.body).to eq 'New question body'
      end

      it 'render update template' do
        patch :update, params: params, format: :js
        expect(response).to render_template :update
      end
    end

    context 'is not author' do
      let(:user) { create(:user) }
      let(:question) { user.questions.create(title: 'My question title', body: 'My question body') }
      let(:params) do {
        id: question,
        question: { title: 'New question title', body: 'New question body' }
        }
      end

      it 'does not change question attributes' do
        patch :update, params: params, format: :js
        question.reload
        expect(question.title).to_not eq 'New question title'
        expect(question.body).to_not eq 'New question body'
      end

    end
  end
end
