require 'rails_helper'

RSpec.describe Vote, type: :model do
  it { should belong_to :votable }
  it { should belong_to :user }

  it 'calls Reputation.update after create/destroy' do
    expect(Reputation).to receive(:update).exactly(3).times

    vote = create(:vote, :upvote)
    vote.destroy
  end

  describe 'it changes reputation on create' do
    let(:user) { create(:user) }

    context 'when votable is answer' do
      let(:answer) { create(:answer) }

      it 'by 1' do
        expect{ create(:vote, :upvote, user: user, votable: answer) }.to change(answer.user, :reputation).by 1
      end
    end

    context 'when votable is question' do
      let(:question) { create(:question) }

      it 'by 2' do
        expect{ create(:vote, :upvote, user: user, votable: question) }.to change(question.user, :reputation).by 2
      end
    end
  end

  describe 'it changes reputation on destroy' do
    let(:user) { create(:user) }

    context 'when votable is answer' do
      let(:answer) { create(:answer) }

      it 'by -1' do
        vote = create(:vote, :upvote, user: user, votable: answer)
        expect{ vote.destroy }.to change(answer.user, :reputation).by -1
      end
    end

    context 'when votable is question' do
      let(:question) { create(:question) }

      it 'by -2' do
        vote = create(:vote, :upvote, user: user, votable: question)
        expect{ vote.destroy }.to change(question.user, :reputation).by -2
      end
    end
  end
end
