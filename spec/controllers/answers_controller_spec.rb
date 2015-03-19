require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  describe 'POST #create' do
    sign_in_user
    let(:question) { create(:question) }

    context 'with valid info' do
      it 'saves answer in db and associates it with a proper question' do
        expect{ post :create, question_id: question.id, 
                answer: attributes_for(:answer) }.
                to change(question.answers, :count).by(1)
      end

      it 'redirects to questions page' do
        post :create, question_id: question.id, 
                answer: attributes_for(:answer)
        expect(response).to redirect_to question_path(question.id)
      end
    end

    context 'with invalid info' do
      it 'does not create answer in database' do
        expect{ post :create, question_id: question.id, 
                answer: attributes_for(:answer, body: nil) }.
                to_not change(Answer, :count)
      end
      
      it 're-renders questions page' do
        post :create, question_id: question.id, 
                answer: attributes_for(:answer, body: nil)
        expect(response).to render_template(:show)
      end
    end

    context 'when user is not logged in' do
      before { sign_out @user }

      it 'does not save answer in db' do
        expect{ post :create, question_id: question.id, 
                answer: attributes_for(:answer) }.
                to_not change(Answer, :count)
      end

      it 'redirects to sign in page' do
        post :create, question_id: question.id, 
                answer: attributes_for(:answer)
        expect(response).to redirect_to new_user_session_path
      end
    end
  end
end
