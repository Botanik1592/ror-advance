require 'rails_helper'

describe 'Answers API' do
  let!(:question) { create(:question) }

  describe 'GET #index' do
    let(:http_method) { :get }
    let(:path) { "/api/v1/questions/#{question.id}/answers" }

    it_behaves_like 'API authenticable'

    context 'authorized' do
      let!(:answers) { create_list(:answer, 2, question: question) }
      let!(:first_answer) { answers.first }
      let(:access_token) { create(:access_token) }

      before do
        get "/api/v1/questions/#{question.id}/answers", params: { access_token: access_token.token, format: :json }
      end

      it 'returns 200 status code' do
        expect(response.status).to eq 200
      end

      it 'returns list of answers' do
        expect(response.body).to have_json_size(2).at_path('answers')
      end

      %w(id body created_at updated_at user_id best).each do |attr|
        it "answer object contains #{attr}" do
          expect(response.body).to be_json_eql(first_answer.send(attr.to_sym).to_json).at_path("answers/0/#{attr}")
        end
      end
    end
  end

  describe 'GET #show' do
    let!(:answer) { create(:answer, question: question) }
    let!(:comment) { create(:answer_comment, commentable: answer) }
    let!(:attachment) { create(:answer_attachment, attachmentable: answer) }
    let(:http_method) { :get }
    let(:path) { "/api/v1/answers/#{answer.id}" }

    it_behaves_like 'API authenticable'

    context 'authorized' do
      let(:access_token) { create(:access_token) }

      before do
        get "/api/v1/answers/#{answer.id}", params: { access_token: access_token.token, format: :json }
      end

      it 'returns 200 status code' do
        expect(response.status).to eq 200
      end

      it 'returns the answer' do
        expect(response.body).to have_json_size(1)
      end

      %w(id body created_at updated_at user_id best).each do |attr|
        it "answer object contains #{attr}" do
          expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path("answer/#{attr}")
        end
      end

      %w(id body user_id).each do |attr|
        it "answer's comment object contains #{attr}" do
          expect(response.body).to be_json_eql(comment.send(attr.to_sym).to_json).at_path("answer/comments/0/#{attr}")
        end
      end

      %w(id created_at).each do |attr|
        it "answer's attachment object contains #{attr}" do
          expect(response.body).to be_json_eql(attachment.send(attr.to_sym).to_json).at_path("answer/attachments/0/#{attr}")
        end
      end

      it "answer's attachment object contains filename" do
        expect(response.body).to be_json_eql(attachment.file.identifier.to_json).at_path("answer/attachments/0/filename")
      end

      it "answer's attachment object contains url" do
        expect(response.body).to be_json_eql(attachment.file.url.to_json).at_path("answer/attachments/0/url")
      end
    end
  end

  describe 'POST #create' do
    let(:http_method) { :post }
    let(:path) { "/api/v1/questions/#{question.id}/answers" }

    it_behaves_like 'API authenticable'

    context 'authorized and post valid data' do
      let(:user) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: user.id) }
      let(:params) do
        {
          answer: { body: 'This is new answer body' },
          question_id: question.id,
          access_token: access_token.token,
          format: :json
        }
      end

      before do
        post "/api/v1/questions/#{question.id}/answers", params: params
      end

      it 'returns 201 status code' do
        expect(response.status).to eq 201
      end

      it 'creates new answer in db with author' do
        expect { post "/api/v1/questions/#{question.id}/answers", params: params }.to change(user.answers, :count).by(1)
      end

      it 'creates new answer in db with question' do
        expect { post "/api/v1/questions/#{question.id}/answers", params: params }.to change(question.answers, :count).by(1)
      end
    end

    context 'authorized and post invalid data' do
      let(:user) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: user.id) }
      let(:params) do
        {
          answer: { body: nil },
          question_id: question.id,
          access_token: access_token.token,
          format: :json
        }
      end

      before do
        post "/api/v1/questions/#{question.id}/answers", params: params
      end

      it 'returns 422 status code' do
        expect(response.status).to eq 422
      end

      it 'returns errors' do
        expect(response.body).to have_json_size(2).at_path("errors/body")
      end

      it 'does not creates anwer in db' do
        expect { post "/api/v1/questions/#{question.id}/answers", params: params }.not_to change(Answer, :count)
      end
    end
  end
end
