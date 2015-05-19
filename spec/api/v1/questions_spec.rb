require 'rails_helper'

describe 'Questions API' do
  describe 'GET /index' do
    context 'unauthorized' do
      it 'returns 401 if no access token is supplied' do
        get '/api/v1/questions', format: :json
        expect(response.status).to eq 401
      end

      it 'returns 401 if access token is invalid' do
        get '/api/v1/questions', format: :json, access_token: '1234'
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let!(:questions) { create_list(:question, 2) }
      let(:question) { questions.last }
      let!(:answer) { create(:answer, question: question) }

      before { get '/api/v1/questions', format: :json, access_token: access_token.token }

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
  end

  describe 'GET /show' do
    let(:question) { create(:question) }
    let(:access_token) { create(:access_token) }
 
    context 'unauthorized' do
      it 'returns 401 if no access token is supplied' do
        get "/api/v1/questions/#{question.id}", format: :json
        expect(response.status).to eq 401
      end

      it 'returns 401 if access token is invalid' do
        get "/api/v1/questions/#{question.id}", format: :json, access_token: '1234'
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      let!(:comments) { create_list(:comment, 2, commentable: question) }
      let!(:attachment) { create(:attachment, attachable: question) }

      before { get "/api/v1/questions/#{question.id}", format: :json, access_token: access_token.token }

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
  end

  describe 'POST /create' do
    let(:user) { create(:user) }
    let(:access_token) { create(:access_token, resource_owner_id: user.id) }
 
    context 'unauthorized' do
      it 'returns 401 if no access token is supplied' do
        post "/api/v1/questions", question: attributes_for(:question), format: :json
        expect(response.status).to eq 401
      end

      it 'returns 401 if access token is invalid' do
        post "/api/v1/questions", question: attributes_for(:question), format: :json, access_token: '1234'
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      let(:post_request) { post "/api/v1/questions", question: attributes_for(:question), format: :json, access_token: access_token.token }

      it 'returns 201' do
        post_request
        expect(response.status).to eq 201
      end

      it 'creates new question tied to resource owner'  do
        expect{post_request}.to change(user.questions, :count).by 1
      end
    end
  end
end