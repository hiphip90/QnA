require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do

  describe 'GET #index' do
    before { get :index }

    it 'populates questions array' do
      questions = create_list(:question, 2)
      expect(assigns(:questions)).to match_array(questions)
    end

    it 'renders index view' do
      expect(response).to render_template(:index)
    end
  end

  describe 'GET #new' do
    let(:user) { create(:user) }
    before do 
      sign_in(user)
      get :new
    end

    it 'assigns new question variable' do
      expect(assigns(:question)).to_not be_nil
    end

    it 'assigns new attachment' do
      expect(assigns(:question).attachments.first).to be_a_new(Attachment)
    end

    it 'renders new view' do
      expect(response).to render_template(:new)
    end

    context 'when user is not logged in' do
      it 'redirects to signin page' do 
        sign_out user
        get :new
        expect(response).to redirect_to new_user_session_path
      end
    end
  end   

  describe 'GET #show' do
    let(:question) { create(:question) }
    before { get :show, id: question }

    it 'assigns the requested question' do
      expect(assigns(:question)).to eq question
    end

    it 'renders show view' do
      expect(response).to render_template(:show)
    end

    it 'assigns blank new answer to a variable' do
      expect(assigns(:answer)).to_not be_nil
    end

    it 'assigns new attachment for answer' do
      expect(assigns(:answer).attachments.first).to be_a_new(Attachment)
    end
  end

  describe 'POST #create' do
    let(:user) { create(:user) }
    before do 
      sign_in(user)
    end

    context 'with valid parameters' do
      let(:post_with_valid_params) { post :create, question: attributes_for(:question) }

      it 'saves question in db and assigns it to user' do
        expect { post_with_valid_params }.to change(user.questions, :count).by(1)
      end

      it 'redirects to question page' do
        post_with_valid_params
        expect(response).to redirect_to question_path(Question.last)
      end

      it 'sets flash message' do
        post_with_valid_params
        expect(flash[:success]).to_not be_nil
      end
    end
    
    context 'with invalid parameters' do
      let(:post_with_invalid_params) do 
        post :create, question: attributes_for(:question, :invalid)
      end

      it 'does not save question in db' do
        expect { post_with_invalid_params }.to_not change(Question, :count)
      end

      it 'renders new template' do
        post_with_invalid_params
        expect(response).to render_template(:new)
      end
    end

    context 'when user is not logged in' do
      before { sign_out user }
      let(:post_with_valid_params) { post :create, question: attributes_for(:question) }

      it 'does not save question in db' do
        expect { post_with_valid_params }.to_not change(Question, :count)
      end

      it 'redirects to sign in page' do
        post_with_valid_params
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:user) { create(:user, :author) }
    let!(:another_user) { create(:user, :author) }
    before do
      sign_in(user)
    end

    context 'when current user is the author' do
      let(:destroy_correct_question) { delete :destroy, id: user.questions.last.id }

      it 'deletes question from db' do
        expect{ destroy_correct_question }.to change(Question, :count).by(-1)
      end

      it 'redirects to root on successful destroy' do
        destroy_correct_question
        expect(response).to redirect_to root_path
      end

      it 'shows sets flash message' do
        destroy_correct_question
        expect(flash[:success]).to_not be_nil
      end
    end

    context 'when current user is not the author' do
      let(:destroy_incorrect_question) { delete :destroy, id: another_user.questions.last.id }

      it 'does not delete question' do
        expect{ destroy_incorrect_question }.to_not change(Question, :count)
      end

      it 'redirects to root' do
        destroy_incorrect_question
        expect(response).to redirect_to root_path
      end
    end

    context 'when user is not logged in' do
      before { sign_out user }
      let(:destroy_question) { delete :destroy, id: user.questions.last.id }

      it 'does not delete question' do
        expect{ destroy_question }.to_not change(Question, :count)
      end

      it 'redirects to sign in page' do
        destroy_question
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe 'PATCH #update' do
    let(:user) { create(:user, :author) }
    let(:question) { user.questions.last }
    let(:other_user) { create(:user) }

    before do
      sign_in(user)
    end

    context 'when current user is an author' do
      before do
        patch :update, id: question.id, question: { title: "Edited title", body: "Edited body" }, format: :js
      end

      it 'updates question in db' do
        question.reload

        expect(question.title).to eq "Edited title"
        expect(question.body).to eq "Edited body"
      end

      it 'renders update template' do
        expect(response).to render_template :update
      end
    end

    context 'when current user is not an author' do
      before do
        question.update(user: other_user)
        patch :update, id: question.id, question: { title: "Edited title", body: "Edited body" }, format: :js
      end

      it 'does not update question in db' do
        question.reload

        expect(question.title).to_not eq "Edited title"
        expect(question.body).to_not eq "Edited body"
      end

      it 'responds with 400' do
        expect(response.status).to eq 400
      end
    end
  end

  describe 'PATCH #upvote' do
    let(:user) { create(:user) }
    let(:question) { create(:question) }
    let(:upvote) { patch :upvote, id: question.id, format: :json }

    before { sign_in user }

    it 'increases the questions rating' do
      expect{upvote}.to change(question, :rating).by 1
    end

    it 'renders vote template' do
      upvote
      expect(response).to render_template :vote
    end

    context 'when user is not logged in' do
      before do
        sign_out user
      end

      it 'does not increase rating' do
        expect{upvote}.to_not change(question, :rating)
      end
    end
  end

  describe 'PATCH #downvote' do
    let(:user) { create(:user) }
    let(:question) { create(:question) }
    let(:downvote) { patch :downvote, id: question.id, format: :json }

    before { sign_in user }

    it 'decreases the questions rating' do
      expect{downvote}.to change(question, :rating).by -1
    end

    it 'renders vote template' do
      downvote
      expect(response).to render_template :vote
    end

    context 'when user is not logged in' do
      before do
        sign_out user
      end

      it 'does not increase rating' do
        expect{downvote}.to_not change(question, :rating)
      end
    end
  end

  describe 'PATCH #recall_vote' do
    let(:user) { create(:user) }
    let(:question) { create(:question) }
    let(:recall_vote) { patch :recall_vote, id: question.id, format: :json }

    before do
      sign_in user
      user.upvote(question)
    end

    it 'deletes users vote' do
      expect{ recall_vote }.to change(user.votes, :count).by -1
    end

    it 'deletes correct vote' do
      expect{ recall_vote }.to change(question.votes, :count).by -1
    end

    context 'when user is not logged in' do
      before do
        sign_out user
      end

      it 'does not delete vote' do
        expect{ recall_vote }.to_not change(Vote, :count)
      end
    end
  end
end
