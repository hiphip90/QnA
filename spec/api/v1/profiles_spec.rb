require 'rails_helper'

describe 'Profile API' do
  describe 'GET #me' do
    context 'unauthorized' do
      it 'returns 401 if no access token is supplied' do
        get '/api/v1/profiles/me', format: :json
        expect(response.status).to eq 401
      end

      it 'returns 401 if access token is invalid' do
        get '/api/v1/profiles/me', format: :json, access_token: '1234'
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      let(:me) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }

      before { get '/api/v1/profiles/me', format: :json, access_token: access_token.token }

      it 'returns 200' do
        expect(response.status).to eq 200
      end

      %w{id email created_at updated_at admin}.each do |attr|
        it "contains #{attr}" do
          expect(response.body).to be_json_eql(me.send(attr.to_sym).to_json).at_path(attr)
        end
      end

      %w{password encrypted_password}.each do |attr|
        it "contains #{attr}" do
          expect(response.body).to_not have_json_path(attr)
        end
      end
    end
  end

  describe 'GET #all' do
    let(:me) { create(:user) }
    let!(:users) { create_list(:user, 2) }
    let(:access_token) { create(:access_token, resource_owner_id: me.id) }

    before { get '/api/v1/profiles/all', format: :json, access_token: access_token.token }

    it 'returns 200' do
      expect(response.status).to eq 200
    end

    it 'returns all users except currently_authenticated' do
      users.each_with_index do |user, index|
        expect(response.body).to be_json_eql(user.id).at_path("#{index}/id")
      end
    end
  end
end