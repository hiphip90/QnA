shared_examples_for 'votable' do
  it { should have_many :votes }

  let(:votable) { create(described_class.name.underscore.to_sym) }
  let(:voter) { create(:user) }

  describe '#rating' do
    before do
      create_list(:vote, 3, :upvote, votable: votable)
      create(:vote, :downvote, votable: votable)
    end

    it 'returns number of upvotes' do
      expect(votable.rating).to eq 2
    end
  end

  describe '#upvote_by' do
    it 'creates new vote' do
      expect { votable.upvote_by(voter) }.to change(votable.votes, :count).by 1
    end

    it 'assignes correct value to the vote' do
      votable.upvote_by(voter)
      expect(votable.votes.last.value).to eq(1)
    end

    context 'when voter already voted' do
      it 'does not create vote' do
        votable.downvote_by(voter)
        expect { votable.upvote_by(voter) }.to_not change(votable.votes, :count)
      end
    end
  end

  describe '#downvote_by' do
    it 'creates new vote' do
      expect{ votable.downvote_by(voter) }.to change(votable.votes, :count).by 1
    end

    it 'assignes correct value to the vote' do
      votable.downvote_by(voter)
      expect(votable.votes.last.value).to eq(-1)
    end

    context 'when voter already voted' do
      it 'does not create vote' do
        votable.downvote_by(voter)
        expect { votable.downvote_by(voter) }.to_not change(votable.votes, :count)
      end
    end
  end

  describe '#been_voted_by?' do
    it 'returns true if already voted' do
      votable.upvote_by(voter)
      expect(votable.been_voted_by?(voter)).to be_truthy
    end

    it 'returns false otherwise' do
      expect(votable.been_voted_by?(voter)).to be_falsey
    end
  end

  describe '#recall_vote_by' do
    it 'destroys votes by given voter' do
      votable.upvote_by(voter)
      votable.recall_vote_by(voter)
      expect(voter.votes.where(votable: votable).any?).to be_falsey
    end
  end
end
