require 'rails_helper'

RSpec.describe CommentsController, type: :controller do

  describe "POST #create" do
    context "when user is logged in" do
      let(:user) { create(:user) }
      
      before do
        sign_in user
      end

      context "for question" do
        let(:question) { create(:question) }
        let(:post_q) { post :create, question_id: question, comment: attributes_for(:comment), format: :js }

        it "creates new comment" do
          expect{ post_q }.to change(question.comments, :count).by 1
        end
      end

      context "for answer" do
        let(:answer) { create(:answer) }
        let(:post_a) { post :create, answer_id: answer, comment: attributes_for(:comment), format: :js }

        it "creates new comment" do
          expect{ post_a }.to change(answer.comments, :count).by 1
        end
      end
    end

    context "when user is not logged in" do
      let(:question) { create(:question) }
      let(:post_q) { post :create, question_id: question, comment: attributes_for(:comment), format: :js }

      it "does not create new comment" do
        expect{ post_q }.to_not change(Comment, :count)
      end
    end
  end
end
