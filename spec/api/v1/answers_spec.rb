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
end