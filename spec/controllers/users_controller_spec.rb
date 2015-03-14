require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  describe 'GET #index' do
    before { get :index }

    it 'populates users array' do
      questions = create_list(:user, 2)
      expect(assigns(:users)).to match_array(questions)
    end
    it 'renders index view' do
      expect(response).to render_template(:index)
    end
  end

  describe 'GET #new' do
    before { get :new }

    it 'assigns new user' do
      expect(assigns(:user)).to_not be_nil
    end
    it 'renders new view' do
      expect(response).to render_template(:new)
    end
  end

  describe 'POST #create' do
    context 'with valid user info' do
      it 'creates a user in db' do
        expect { post :create, user: attributes_for(:user) }.to change(User, :count).by(1)
      end
      it 'redirects to index page' do
        post :create, user: attributes_for(:user)
        expect(response).to redirect_to(users_path)
      end
    end
    context 'with invalid user info' do
      it 'does not create user in db' do
        expect { post :create, user: { name: nil, email: nil } }.not_to change(User, :count)
      end
      it 're-renders new view' do
        post :create, user: { name: nil, email: nil }
        expect(response).to render_template(:new)
      end
    end
  end

  describe 'DELETE #destroy' do
    let (:user) { create(:user) }

    it 'deletes user from db' do
      user
      expect { delete :destroy, id: user }.to change(User, :count).by(-1)
    end

    it 'redirects to index page' do
      user
      delete :destroy, id: user
      expect(response).to redirect_to(users_path)
    end
  end
end
