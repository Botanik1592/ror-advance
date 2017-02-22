require 'rails_helper'

describe 'Profile API' do
  describe 'GET /me' do
    context 'unauthorized' do
      it 'returns 401 status if no access token' do
        get '/api/v1/profiles/me', params: { format: :json }

        expect(response.status).to eq 401
      end

      it 'returns 401 status if access token invalid' do
        get '/api/v1/profiles/me', params: { format: :json, access_token: '1234' }

        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      let(:me) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }

      before { get '/api/v1/profiles/me', params: { format: :json, access_token: access_token.token } }

      it 'returns 200 status' do
        expect(response).to be_success
      end

      %w(email id created_at updated_at admin).each do |attrib|
        it "contains #{attrib}" do
          expect(response.body).to be_json_eql(me.send(attrib.to_sym).to_json).at_path(attrib)
        end
      end

      %w(password encrypted_password).each do |attrib|
        it 'does not contain password' do
          expect(response.body).not_to have_json_path(attrib)
        end
      end
    end
  end

  describe 'GET #index' do
    context 'unauthorized' do
      it 'returns 401 status if no access token' do
        get '/api/v1/profiles', params: { format: :json }

        expect(response.status).to eq 401
      end

      it 'returns 401 status if access token is invalid' do
        get '/api/v1/profiles', params: { format: :json, access_token: '1234' }

        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      let!(:users) { create_list(:user, 3) }
      let(:access_token) { create(:access_token, resource_owner_id: users.first.id) }

      before do
        get '/api/v1/profiles', params: { format: :json, access_token: access_token.token }
      end

      it 'returns 200 status' do
        expect(response).to be_success
      end

      it 'returns all users with attributes, without current user' do
        response_items = JSON.parse(response.body)
        attrib = %w(id email created_at updated_at admin)

        expect(response_items.size).to eq(2)
        expect(response_items[0].sort.to_json).to eq(users[1].attributes.slice(*attrib).sort.to_json)
        expect(response_items[1].sort.to_json).to eq(users[2].attributes.slice(*attrib).sort.to_json)
      end
    end
  end
end
