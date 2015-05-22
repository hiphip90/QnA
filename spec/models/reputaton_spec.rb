require "rails_helper"

RSpec.describe Reputation, type: :model do
  
  describe ".update" do
    let(:user) { create(:user) }

    context "when action is create answer" do
      it 'increases reputation by 1' do
        expect { Reputation.update(user, :create_answer) }.to change(user, :reputation).by 1
      end

      context "when first answer" do
        it 'increases reputation by 2' do
          expect { Reputation.update(user, :create_answer, first: true) }.to change(user, :reputation).by 2
        end
      end

      context "when answer to own question" do
        it 'increases reputation by 2' do
          expect { Reputation.update(user, :create_answer, to_own_question: true) }.to change(user, :reputation).by 2
        end
      end
    end

    context "when action is accept answer" do
      it 'increases reputation by 3' do
        expect { Reputation.update(user, :accept_answer) }.to change(user, :reputation).by 3
      end
    end

    context "when action is accept answer" do
      it 'increases reputation by 3' do
        expect { Reputation.update(user, :accept_answer) }.to change(user, :reputation).by 3
      end
    end

    context "when action is recall accept answer" do
      it 'increases reputation by -3' do
        expect { Reputation.update(user, :recall_accept_answer) }.to change(user, :reputation).by -3
      end
    end

    context "when action is destroy answer" do
      it 'decreases reputation by 1' do
        expect { Reputation.update(user, :destroy_answer) }.to change(user, :reputation).by -1
      end

      context "when first answer" do
        it 'decreases reputation by 2' do
          expect { Reputation.update(user, :destroy_answer, first: true) }.to change(user, :reputation).by -2
        end
      end

      context "when answer to own question" do
        it 'decreases reputation by 2' do
          expect { Reputation.update(user, :destroy_answer, to_own_question: true) }.to change(user, :reputation).by -2
        end
      end

      context "when accepted" do
        it 'decreases reputation by 4' do
          expect { Reputation.update(user, :destroy_answer, accepted: true) }.to change(user, :reputation).by -4
        end
      end
    end

    context "when action is upvote" do
      it 'increases reputation by 1 when answer' do
        expect { Reputation.update(user, :vote_answer, upvote: true) }.to change(user, :reputation).by 1
      end

      it 'increases reputation by 2 when question' do
        expect { Reputation.update(user, :vote_question, upvote: true) }.to change(user, :reputation).by 2
      end
    end

    context "when action is downvote" do
      it 'decreases reputation by 1 when answer' do
        expect { Reputation.update(user, :vote_answer) }.to change(user, :reputation).by -1
      end

      it 'decreases reputation by 2 when question' do
        expect { Reputation.update(user, :vote_question) }.to change(user, :reputation).by -2
      end
    end
  end
end
