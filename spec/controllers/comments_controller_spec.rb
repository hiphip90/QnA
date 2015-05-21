require 'rails_helper'
require_relative 'shared_examples/publishing'

RSpec.describe CommentsController, type: :controller do

  describe "POST #create" do
    context "when user is logged in" do
      let(:user) { create(:user) }
      
      before do
        sign_in user
      end

      context "for question" do
        let(:publish_url) { "/questions/#{question.id}/comments" }
        let(:question) { create(:question) }
        let(:make_request) { post :create, commentable: 'question', question_id: question, comment: attributes_for(:comment), format: :js }
        
        it_behaves_like 'publishing'

        it "creates new comment" do
          expect{ make_request }.to change(question.comments, :count).by 1
        end
      end

      context "for answer" do
        let(:publish_url) { "/questions/#{answer.id}/comments" }
        let(:answer) { create(:answer) }
        let(:make_request) { post :create, commentable: 'answer', answer_id: answer, comment: attributes_for(:comment), format: :js }

        it_behaves_like 'publishing'

        it "creates new comment" do
          expect{ make_request }.to change(answer.comments, :count).by 1
        end
      end
    end

    context "when user is not logged in" do
      let(:question) { create(:question) }
      let(:make_request) { post :create, commentable: 'question', question_id: question, comment: attributes_for(:comment), format: :js }

      it "does not create new comment" do
        expect{ make_request }.to_not change(Comment, :count)
      end
    end
  end
end
