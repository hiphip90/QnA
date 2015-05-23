require 'rails_helper'
require_relative 'shared_examples/api_authentication'

describe 'Answers API' do
  describe 'GET /index' do
    let(:question) { create(:question, :with_answers) }
    let(:access_token) { create(:access_token) }

    it_behaves_like "api authenticatable"

    before { make_request(access_token: access_token.token) }

    context 'authorized' do
      it 'returns 200' do
        expect(response.status).to eq 200
      end

      it 'returns list of answers' do
        expect(response.body).to have_json_size(5).at_path("answers")
      end

      %w{id body created_at updated_at}.each do |attr|
        it "question object contains #{attr}" do
          expect(response.body).to be_json_eql(question.answers.first.send(attr.to_sym).to_json).at_path("answers/0/#{attr}")
        end
      end
    end

    def make_request(options = {})
      get "/api/v1/questions/#{question.id}/answers", { format: :json }.merge(options)
    end
  end

  describe 'GET /show' do
    let(:question) { create(:question) }
    let(:answer) { create(:answer, question: question) }
    let(:access_token) { create(:access_token) }
    let!(:comments) { create_list(:comment, 2, commentable: answer) }
    let!(:attachment) { create(:attachment, attachable: answer) }
 
    it_behaves_like "api authenticatable"

    before { make_request(access_token: access_token.token) }

    context 'authorized' do
      it 'returns 200' do
        expect(response.status).to eq 200
      end

      %w{id body created_at updated_at}.each do |attr|
        it "answer object contains #{attr}" do
          expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path("answer/#{attr}")
        end
      end

      context 'comments' do
        it 'included in question object' do
          expect(response.body).to have_json_size(2).at_path("answer/comments")
        end

        %w{id body created_at updated_at}.each do |attr|
          it "contains #{attr}" do
            expect(response.body).to be_json_eql(comments.first.send(attr.to_sym).to_json).at_path("answer/comments/0/#{attr}")
          end
        end
      end

      context 'attachments' do
        it 'included in answer object' do
          expect(response.body).to have_json_size(1).at_path("answer/attachments")
        end

        it 'contains attachment url' do
          expect(response.body).to be_json_eql(attachment.file.url.to_json).at_path("answer/attachments/0/file_url")
        end
      end
    end

    def make_request(options = {})
      get "/api/v1/questions/#{question.id}/answers/#{answer.id}", { format: :json }.merge(options)
    end
  end

  describe 'POST /create' do
    let(:api_url) { "/api/v1/questions/#{question.id}/answers" }
    let(:user) { create(:user) }
    let(:question) { create(:question) }
    let(:access_token) { create(:access_token, resource_owner_id: user.id) }

    it_behaves_like "api authenticatable"
 
    context 'unauthorized' do
      context 'no token' do
        let(:post_without_token) { make_request(answer: attributes_for(:answer)) }

        it 'does not create an answer' do
          expect{ post_without_token }.to_not change(Answer, :count)
        end
      end

      context 'invalid token' do
        let(:post_with_invalid_token) { make_request(answer: attributes_for(:answer), access_token: '1234') }

        it 'does not create an answer' do
          expect{ post_with_invalid_token }.to_not change(Answer, :count)
        end
      end
    end

    context 'authorized' do
      let(:post_request) { make_request(answer: attributes_for(:answer), access_token: access_token.token) }

      it 'returns 201' do
        post_request
        expect(response.status).to eq 201
      end

      it 'creates new answer tied to resource owner'  do
        expect{post_request}.to change(user.answers, :count).by 1
      end

      it 'associates answer to question'  do
        expect{post_request}.to change(question.answers, :count).by 1
      end
    end

    def make_request(options = {})
      post "/api/v1/questions/#{question.id}/answers", { format: :json }.merge(options)
    end
  end
end