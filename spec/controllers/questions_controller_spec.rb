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
    before { get :new }

    it 'assigns new question variable' do
      expect(assigns(:question)).to_not be_nil
    end
    it 'renders new view' do
      expect(response).to render_template(:new)
    end
  end

  describe 'GET #show' do
    let(:question) { create(:question) }
    before { get :show, id: question }

    it 'assigns the requested question' do
      expect(assigns(:question)).to eq question
    end
    it 'assigns author to the user varibale' do
      author = User.find(question.user_id)
      expect(assigns(:user)).to eq author
    end
    it 'renders show view' do
      expect(response).to render_template(:show)
    end
  end

  describe 'POST #create' do
    let (:user) { create(:user) }
    context 'with valid parameters' do
      it 'saves question in db' do
        expect { post :create, question: attributes_for(:question, user_id: user.id) }.
                                                        to change(user.questions, :count).by(1)
      end
      it 'redirects to question page' do
        post :create, question: attributes_for(:question, user_id: user.id)
        expect(response).to redirect_to question_path(Question.last)
      end
    end
    context 'with invalid parameters' do
      it 'does not save question in db' do
        expect { post :create, question: attributes_for(:question,
                              :invalid, user_id: user.id) }.to_not change(user.questions, :count)
      end
      it 'renders new template' do
        post :create, question: attributes_for(:question,:invalid, user_id: user.id)
        expect(response).to render_template(:new)
      end
    end
  end
end
