require 'rails_helper'

RSpec.describe NewAnswerSubscriptionsController, type: :controller do

  describe "POST #create" do
    context "when user is logged in" do
      let!(:user) { create(:user) }
      let!(:question) { create(:question) }
      
      before do
        sign_in user
      end

      it 'subscribes user to question' do
        post :create, question_id: question.id

        expect(user.questions_subscribed_to).to include(question)
      end
    end
  end
end
