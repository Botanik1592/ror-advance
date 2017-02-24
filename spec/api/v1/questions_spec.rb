require 'rails_helper'

describe 'Questions API' do
  describe 'GET #index' do

    it 'returns 401 status if there is no access token' do
      get '/api/v1/questions', params: { format: :json }
      expect(response.status).to eq 401
    end

    it 'returns 401 status if access token is invalid' do
      get '/api/v1/questions', params: { access_token: '1234', format: :json }
      expect(response.status).to eq 401
    end

    context 'authorized' do
      let!(:questions) { create_list(:question, 2) }
      let!(:question) { questions.first }
      let(:access_token) { create(:access_token) }
      let!(:answer) { create(:answer, question: question) }

      before do
        get '/api/v1/questions', params: { access_token: access_token.token, format: :json }
      end

      it 'returns 200 status code' do
        expect(response.status).to eq 200
      end

      it 'returns list of questions' do
        expect(response.body).to have_json_size(2).at_path('questions')
      end

      %w(id title body created_at updated_at user_id ratings).each do |attr|
        it "question object contains #{attr}" do
          expect(response.body).to be_json_eql(question.send(attr.to_sym).to_json).at_path("questions/0/#{attr}")
        end
      end

      context 'answers' do
        it 'included in question object' do
          expect(response.body).to have_json_size(1).at_path("questions/0/answers")
        end

        %w(id body created_at updated_at user_id best).each do |attr|
          it "answer object contains #{attr}" do
            expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path("questions/0/answers/0/#{attr}")
          end
        end
      end
    end
  end

  describe 'GET #show' do
    let(:question) { create(:question) }
    let!(:comment) { create(:question_comment, commentable: question) }
    let!(:attachment) { create(:question_attachment, attachmentable: question) }

    it 'returns 401 status if there is no access token' do
      get "/api/v1/questions/#{question.id}", params: { format: :json }
      expect(response.status).to eq 401
    end

    it 'returns 401 status if access token is invalid' do
      get "/api/v1/questions/#{question.id}", params: { access_token: '1234', format: :json }
      expect(response.status).to eq 401
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }

      before do
        get "/api/v1/questions/#{question.id}", params: { access_token: access_token.token, format: :json }
      end

      it 'returns 200 status code' do
        expect(response.status).to eq 200
      end

      it 'returns the question' do
        expect(response.body).to have_json_size(1)
      end

      %w(id title body created_at updated_at user_id ratings).each do |attr|
        it "question object contains #{attr}" do
          expect(response.body).to be_json_eql(question.send(attr.to_sym).to_json).at_path("question/#{attr}")
        end
      end

      %w(id body user_id).each do |attr|
        it "question's comment contains #{attr}" do
          expect(response.body).to be_json_eql(comment.send(attr.to_sym).to_json).at_path("question/comments/0/#{attr}")
        end
      end

      %w(id created_at).each do |attr|
        it "question's attachment contains #{attr}" do
          expect(response.body).to be_json_eql(attachment.send(attr.to_sym).to_json).at_path("question/attachments/0/#{attr}")
        end
      end

      it "question's attachment contains filename" do
        expect(response.body).to be_json_eql(attachment.file.identifier.to_json).at_path("question/attachments/0/filename")
      end

      it "question's attachment contains url" do
        expect(response.body).to be_json_eql(attachment.file.url.to_json).at_path("question/attachments/0/url")
      end
    end
  end

  describe 'POST #create' do

    it 'returns 401 status if there is no access_token' do
      post '/api/v1/questions/', params: { question: attributes_for(:question), format: :json }
      expect(response.status).to eq 401
    end

    it 'returns 401 status if access_token is invalid' do
      post '/api/v1/questions/', params: { question: attributes_for(:question), access_token: '1234', format: :json }
      expect(response.status).to eq 401
    end

    context 'authorized and post valid data' do
      let(:user) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: user.id) }
      let(:params) do
        {
          question: { title: 'This is new question title', body: 'This is new question body' },
          access_token: access_token.token,
          format: :json
        }
      end

      before do
        post '/api/v1/questions/', params: params
      end

      it 'returns 201 status code' do
        expect(response.status).to eq 201
      end

      it 'creates new question in db' do
        expect { post '/api/v1/questions/', params: params }.to change(user.questions, :count).by(1)
      end
    end

    context 'authorized and post invalid data' do
      let(:user) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: user.id) }
      let(:params) do
        {
          question: { title: 'This is new invalid question title', body: nil },
          access_token: access_token.token,
          format: :json
        }
      end

      before do
        post '/api/v1/questions/', params: params
      end

      it 'returns 422 status code' do
        expect(response.status).to eq 422
      end

      it 'returns errors' do
        expect(response.body).to have_json_size(2).at_path("errors/body")
      end

      it 'does not creates question in db' do
        expect { post '/api/v1/questions/', params: params }.not_to change(Question, :count)
      end
    end
  end
end
