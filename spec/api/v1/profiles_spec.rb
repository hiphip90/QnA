require 'rails_helper'
require_relative 'shared_examples/api_authentication'

describe 'Profile API' do
  describe 'GET #me' do
    let(:me) { create(:user) }
    let(:access_token) { create(:access_token, resource_owner_id: me.id) }

    it_behaves_like "api authenticatable"

    before { make_request(access_token: access_token.token) }

    context 'authorized' do
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

    def make_request(options = {})
      get '/api/v1/profiles/me', { format: :json }.merge(options)
    end
  end

  describe 'GET #all' do
    let(:me) { create(:user) }
    let!(:users) { create_list(:user, 2) }
    let(:access_token) { create(:access_token, resource_owner_id: me.id) }

    it_behaves_like "api authenticatable"

    before { make_request(access_token: access_token.token) }

    it 'returns 200' do
      expect(response.status).to eq 200
    end

    it 'returns all users' do
      users.each_with_index do |user, index|
        expect(response.body).to be_json_eql(user.id).at_path("profiles/#{index}/id")
      end
    end

    it 'does not return current user' do
      response_hash = JSON.parse(response.body)
      response_hash['profiles'].each do |user|
        expect(user[:id]).to_not eq(me.id)
      end
    end

    def make_request(options = {})
      get '/api/v1/profiles/all', { format: :json }.merge(options)
    end
  end
end