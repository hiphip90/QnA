require 'rails_helper'

describe 'Answers API' do
  describe 'GET /index' do
    let(:question) { create(:question, :with_answers) }

    context 'unauthorized' do
      it 'returns 401 if no access token is supplied' do
        get "/api/v1/questions/#{question.id}/answers", format: :json
        expect(response.status).to eq 401
      end

      it 'returns 401 if access token is invalid' do
        get "/api/v1/questions/#{question.id}/answers", format: :json, access_token: '1234'
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }

      before { get "/api/v1/questions/#{question.id}/answers", format: :json, access_token: access_token.token }

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
  end

  describe 'GET /show' do
    let(:question) { create(:question) }
    let(:answer) { create(:answer, question: question) }
    let(:access_token) { create(:access_token) }
 
    context 'unauthorized' do
      it 'returns 401 if no access token is supplied' do
        get "/api/v1/questions/#{question.id}/answers/#{answer.id}", format: :json
        expect(response.status).to eq 401
      end

      it 'returns 401 if access token is invalid' do
        get "/api/v1/questions/#{question.id}/answers/#{answer.id}", format: :json, access_token: '1234'
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      let!(:comments) { create_list(:comment, 2, commentable: answer) }
      let!(:attachment) { create(:attachment, attachable: answer) }

      before { get "/api/v1/questions/#{question.id}/answers/#{answer.id}", format: :json, access_token: access_token.token }

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
  end

  describe 'POST /create' do
    let(:user) { create(:user) }
    let(:question) { create(:question) }
    let(:access_token) { create(:access_token, resource_owner_id: user.id) }
 
    context 'unauthorized' do
      context 'no token' do
        let(:post_without_token) { post "/api/v1/questions/#{question.id}/answers", answer: attributes_for(:answer), format: :json }

        it 'returns 401 if no access token is supplied' do
          post_without_token
          expect(response.status).to eq 401
        end

        it 'does not create an answer' do
          expect{ post_without_token }.to_not change(Answer, :count)
        end
      end

      context 'invalid token' do
        let(:post_with_invalid_token) { post "/api/v1/questions/#{question.id}/answers", answer: attributes_for(:answer), format: :json, access_token: '1234' }

        it 'returns 401 if no access token is supplied' do
          post_with_invalid_token
          expect(response.status).to eq 401
        end

        it 'does not create an answer' do
          expect{ post_with_invalid_token }.to_not change(Answer, :count)
        end
      end
    end

    context 'authorized' do
      let(:post_request) { post "/api/v1/questions/#{question.id}/answers", answer: attributes_for(:answer), format: :json, access_token: access_token.token }

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
  end
end