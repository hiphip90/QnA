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

    it 'renders show view' do
      expect(response).to render_template(:show)
    end

    it 'assigns blank new answer to a variable' do
      expect(assigns(:new_answer)).to_not be_nil
    end
  end

  describe 'POST #create' do
    context 'with valid parameters' do
      it 'saves question in db' do
        expect { post :create, question: attributes_for(:question) }.
                                                        to change(Question, :count).by(1)
      end

      it 'redirects to question page' do
        post :create, question: attributes_for(:question)
        expect(response).to redirect_to question_path(Question.last)
      end
    end
    
    context 'with invalid parameters' do
      it 'does not save question in db' do
        expect { post :create, question: attributes_for(:question,
                              :invalid) }.to_not change(Question, :count)
      end

      it 'renders new template' do
        post :create, question: attributes_for(:question,:invalid)
        expect(response).to render_template(:new)
      end
    end
  end
end
