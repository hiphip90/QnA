require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  sign_in_user
  let(:question) { create(:question) }

  describe 'POST #create' do
    context 'with valid info' do
      it 'saves answer in db and associates it with a proper question' do
        expect{ post :create, question_id: question.id, 
                answer: attributes_for(:answer) }.
                to change(question.answers, :count).by(1)
      end

      it 'associates it with a current user' do
        expect{ post :create, question_id: question.id, 
                answer: attributes_for(:answer) }.
                to change(@user.answers, :count).by(1)
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

  describe 'DELETE #destroy' do
    let(:another_user) { create(:user) }
    let(:delete_answer) { delete :destroy, question_id: question.id, id: @answer.id }
    
    context 'when current user is the author' do
      before do
        @answer = question.answers.create(body: 'smth smth answer')
        @answer.user = @user
        @answer.save
      end

      it 'deletes answer from db' do
        expect{ delete_answer }.to change(Answer, :count).by(-1)
      end

      it 'redirects to question page' do
        delete_answer
        expect(response).to redirect_to question
      end
    end

    context 'when current user is not the author' do
      before do
        @answer = question.answers.create(body: 'smth smth answer')
        @answer.user = @another_user
        @answer.save
      end

      it 'does not delete answer' do
        expect{ delete_answer }.to_not change(Answer, :count)
      end

      it 'redirects to root' do
        delete_answer
        expect(response).to redirect_to root_path
      end
    end

    context 'when user is not logged in' do
      before do
        @answer = question.answers.create(body: 'smth smth answer')
        @answer.user = @user
        @answer.save
        sign_out @user
      end

      it 'does not delete answer' do
        expect{ delete_answer }.to_not change(Answer, :count)
      end

      it 'redirects to sign in' do
        delete_answer
        expect(response).to redirect_to new_user_session_path
      end
    end
  end
end
