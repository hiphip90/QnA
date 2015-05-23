require 'rails_helper'

RSpec.describe Vote, type: :model do
  it { should belong_to :votable }
  it { should belong_to :user }

  it 'calls Reputation.update after create/destroy' do
    expect(Reputation).to receive(:update).exactly(3).times

    vote = create(:vote, :upvote)
    vote.destroy
  end
end
