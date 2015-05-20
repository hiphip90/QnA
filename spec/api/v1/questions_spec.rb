require 'rails_helper'
require_relative 'shared_examples/api_authentication'

describe 'Questions API' do
  describe 'GET /index' do
    let(:access_token) { create(:access_token) }
    let!(:questions) { create_list(:question, 2) }
    let(:question) { questions.last }
    let!(:answer) { create(:answer, question: question) }

    it_behaves_like "api authenticatable"

    before { make_request(access_token: access_token.token) }

    context 'authorized' do
      it 'returns 200' do
        expect(response.status).to eq 200
      end

      it 'returns list of questions' do
        expect(response.body).to have_json_size(2).at_path("questions")
      end

      %w{id title body created_at updated_at}.each do |attr|
        it "question object contains #{attr}" do
          expect(response.body).to be_json_eql(question.send(attr.to_sym).to_json).at_path("questions/0/#{attr}")
        end
      end

      it 'response contains short title' do
        expect(response.body).to be_json_eql(question.title.truncate(10).to_json).at_path("questions/0/short_title")
      end

      context 'answers' do
        it 'included in question object' do
          expect(response.body).to have_json_size(1).at_path("questions/0/answers")
        end

        %w{id body created_at updated_at}.each do |attr|
          it "contains #{attr}" do
            expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path("questions/0/answers/0/#{attr}")
          end
        end
      end
    end

    def make_request(options = {})
      get '/api/v1/questions', { format: :json }.merge(options)
    end
  end

  describe 'GET /show' do
    let(:question) { create(:question) }
    let(:access_token) { create(:access_token) }
    let!(:comments) { create_list(:comment, 2, commentable: question) }
    let!(:attachment) { create(:attachment, attachable: question) }

    it_behaves_like "api authenticatable"

    before { make_request(access_token: access_token.token) }

    context 'authorized' do
      it 'returns 200' do
        expect(response.status).to eq 200
      end

      %w{id title body created_at updated_at}.each do |attr|
        it "question object contains #{attr}" do
          expect(response.body).to be_json_eql(question.send(attr.to_sym).to_json).at_path("question/#{attr}")
        end
      end

      context 'comments' do
        it 'included in question object' do
          expect(response.body).to have_json_size(2).at_path("question/comments")
        end

        %w{id body created_at updated_at}.each do |attr|
          it "contains #{attr}" do
            expect(response.body).to be_json_eql(comments.first.send(attr.to_sym).to_json).at_path("question/comments/0/#{attr}")
          end
        end
      end

      context 'attachments' do
        it 'included in question object' do
          expect(response.body).to have_json_size(1).at_path("question/attachments")
        end

        it 'contains attachment url' do
          expect(response.body).to be_json_eql(attachment.file.url.to_json).at_path("question/attachments/0/file_url")
        end
      end
    end

    def make_request(options = {})
      get "/api/v1/questions/#{question.id}", { format: :json }.merge(options)
    end
  end

  describe 'POST /create' do
    let(:user) { create(:user) }
    let(:access_token) { create(:access_token, resource_owner_id: user.id) }

    it_behaves_like "api authenticatable"
 
    context 'unauthorized' do
      context 'no token' do        
        it 'does not create a question' do
          expect{ make_request(question: attributes_for(:question)) }.to_not change(Question, :count)
        end
      end

      context 'invalid token' do
        it 'does not create a question' do
          expect{ make_request(question: attributes_for(:question), access_token: '1234') }.to_not change(Question, :count)
        end
      end
    end

    context 'authorized' do
      let(:post_request) { make_request(question: attributes_for(:question), access_token: access_token.token) }

      it 'returns 201' do
        post_request
        expect(response.status).to eq 201
      end

      it 'creates new question tied to resource owner'  do
        expect{post_request}.to change(user.questions, :count).by 1
      end
    end

    def make_request(options = {})
      post "/api/v1/questions", { format: :json }.merge(options)
    end
  end
end