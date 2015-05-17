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

    it { should be_able_to :create, Question }
    it { should be_able_to :create, Answer }
    it { should be_able_to :create, Comment }

    it { should be_able_to :update, create(:question, user:user), user: user }
    it { should be_able_to :update, create(:answer, user:user), user: user }

    it { should be_able_to :destroy, create(:question, user:user), user: user }
    it { should be_able_to :destroy, create(:answer, user:user), user: user }

    it { should_not be_able_to :update, create(:question, user: other), user: user }
    it { should_not be_able_to :update, create(:answer, user: other), user: user }

    it { should_not be_able_to :destroy, create(:question, user: other), user: user }
    it { should_not be_able_to :destroy, create(:answer, user: other), user: user }

    context 'to accept' do
      let(:question) { create(:question, user: user) }
      let(:other_question) { create(:question, user: other) }

      it { should be_able_to :accept, create(:answer, question: question), user: user }
      it { should_not be_able_to :accept, create(:answer, question: other_question), user: user }
    end

    context 'to vote' do
      it { should be_able_to :upvote, create(:answer, user: other), user: user }
      it { should be_able_to :downvote, create(:answer, user: other), user: user }
      it { should be_able_to :recall_vote, create(:answer, user: other), user: user }

      it { should_not be_able_to :upvote, create(:answer, user: user), user: user }
      it { should_not be_able_to :downvote, create(:answer, user: user), user: user }
      it { should_not be_able_to :recall_vote, create(:answer, user: user), user: user }
    end
  end
end