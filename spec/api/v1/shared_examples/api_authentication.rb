shared_examples_for "api authenticatable" do
  context 'unauthorized' do
    it 'returns 401 if no access token is supplied' do
      make_request
      expect(response.status).to eq 401
    end

    it 'returns 401 if access token is invalid' do
      make_request(access_token: '1234')
      expect(response.status).to eq 401
    end
  end
end