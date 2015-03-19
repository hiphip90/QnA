require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  sign_in_user
  let(:question) { create(:question) }

  describe 'POST #create' do
    let(:post_valid) { post :create, question_id: question.id, 
                              answer: attributes_for(:answer) }
    let(:post_invalid) { post :create, question_id: question.id, 
                              answer: attributes_for(:answer, body: nil) }

    context 'with valid info' do
      it 'saves answer in db and associates it with a proper question' do
        expect{ post_valid }.to change(question.answers, :count).by(1)
      end

      it 'associates it with a current user' do
        expect{ post_valid }.to change(@user.answers, :count).by(1)
      end

      it 'redirects to questions page' do
        post_valid
        expect(response).to redirect_to question_path(question.id)
      end
    end

    context 'with invalid info' do
      it 'does not create answer in database' do
        expect{ post_invalid }.to_not change(Answer, :count)
      end
      
      it 're-renders questions page' do
        post_invalid
        expect(response).to render_template(:show)
      end
    end

    context 'when user is not logged in' do
      before { sign_out @user }

      it 'does not save answer in db' do
        expect{ post_valid }.to_not change(Answer, :count)
      end

      it 'redirects to sign in page' do
        post_valid
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:answer) { question.answers.create(body: 'smth smth answer') }
    let(:delete_answer) { delete :destroy, question_id: question.id, id: answer.id }
    
    context 'when current user is the author' do
      before { answer.update_attributes(user: @user) }

      it 'deletes answer from db' do
        expect{ delete_answer }.to change(Answer, :count).by(-1)
      end

      it 'redirects to question page' do
        delete_answer
        expect(response).to redirect_to question
      end
    end

    context 'when current user is not the author' do
      let(:another_user) { create(:user) }
      before { answer.update_attributes(user: another_user) }

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
        answer.update_attributes(user: @user)
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
