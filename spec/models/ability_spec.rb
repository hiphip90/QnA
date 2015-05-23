require 'rails_helper'

describe 'Ability' do
  subject(:ability) { Ability.new(user) }

  describe 'for admin' do
    let(:user) { create(:user, admin: true) }

    it { should be_able_to :manage, :all }
  end

  describe 'for guest' do
    let(:user) { nil }

    it { should be_able_to :read, :all }
    it { should_not be_able_to :manage, :all }
  end

  describe 'for user' do
    let(:user) { create(:user) }
    let(:other) { create(:user) }
    let(:users_question) { create(:question, user:user) }
    let(:users_answer) { create(:answer, user:user) }
    let(:others_question) { create(:question, user:other) }
    let(:others_answer) { create(:answer, user:other) }

    it { should be_able_to :create, Question }
    it { should be_able_to :create, Answer }
    it { should be_able_to :create, Comment }

    it { should be_able_to :update, users_question, user: user }
    it { should be_able_to :update, users_answer, user: user }

    it { should be_able_to :destroy, users_question, user: user }
    it { should be_able_to :destroy, users_answer, user: user }

    it { should_not be_able_to :update, others_question, user: user }
    it { should_not be_able_to :update, others_answer, user: user }

    it { should_not be_able_to :destroy, others_question, user: user }
    it { should_not be_able_to :destroy, others_answer, user: user }

    context 'to accept' do
      it { should be_able_to :accept, create(:answer, question: users_question), user: user }
      it { should_not be_able_to :accept, create(:answer, question: users_question, accepted: true), user: user }
      it { should_not be_able_to :accept, create(:answer, question: others_question), user: user }
    end

    context 'to vote' do
      context "when hasn't voted for votable" do
        it { should be_able_to :vote, others_answer, user: user }
        it { should_not be_able_to :recall_vote, others_answer, user: user }

        it { should_not be_able_to :vote, users_answer, user: user }
        it { should_not be_able_to :recall_vote, users_answer, user: user }
      end

      context "when has already voted for votable" do
        before do
          create(:vote, :upvote, user: user, votable: others_answer)
        end

        it { should_not be_able_to :vote, others_answer, user: user }
        it { should be_able_to :recall_vote, others_answer, user: user }
      end
    end

    context 'to subscribe_to' do
      context 'when subscribed' do
        before { user.subscribe_to_new_answers(others_question) }

        it { should_not be_able_to :subscribe_to, others_question, user: user }
      end

      context 'when not subscribed' do
        it { should be_able_to :subscribe_to, others_question, user: user }
      end
    end
  end
end