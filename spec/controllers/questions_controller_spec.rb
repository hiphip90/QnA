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
    sign_in_user
    before { get :new }

    it 'assigns new question variable' do
      expect(assigns(:question)).to_not be_nil
    end

    it 'renders new view' do
      expect(response).to render_template(:new)
    end

    context 'when user is not logged in' do
      it 'redirects to signin page' do 
        sign_out @user
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
      expect(assigns(:new_answer)).to_not be_nil
    end
  end

  describe 'POST #create' do
    sign_in_user

    context 'with valid parameters' do
      let(:post_with_valid_params) { post :create, question: attributes_for(:question) }

      it 'saves question in db' do
        expect { post_with_valid_params }.to change(Question, :count).by(1)
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
      before { sign_out @user }
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
end
