shared_examples_for 'votable' do
  it { should have_many :votes }

  let(:answer) { create(:answer) }

  before do
    create_list(:vote, 3, :upvote, votable: answer)
    create(:vote, :downvote, votable: answer)
  end

  describe '#rating' do
    it 'returns number of upvotes' do
      expect(answer.rating).to eq 2
    end
  end
end

shared_examples_for 'voter' do
  let(:voter) { create(described_class.name.underscore.to_sym) }
  let(:votable) { create(:answer) }
  
  it { should have_many :votes }

  describe '#upvote' do
    it 'creates new vote' do
      expect { voter.upvote votable }.to change(votable.votes, :count).by 1
    end

    it 'assignes correct value to the vote' do
      voter.upvote votable
      expect(votable.votes.last.value).to eq(1)
    end

    context 'when voter already voted' do
      it 'does not create vote' do
        voter.upvote votable
        expect { voter.upvote votable }.to_not change(votable.votes, :count)
      end
    end

    context 'when user is the author' do
      it 'does not create vote' do
        votable.update(user: voter)
        expect { voter.upvote votable }.to_not change(votable.votes, :count)
      end
    end
  end

  describe '#downvote' do
    it 'creates new vote' do
      expect{ voter.downvote votable }.to change(votable.votes, :count).by 1
    end

    it 'assignes correct value to the vote' do
      voter.downvote votable
      expect(votable.votes.last.value).to eq(-1)
    end

    context 'when voter already voted' do
      it 'does not create vote' do
        voter.downvote votable
        expect { voter.downvote votable }.to_not change(votable.votes, :count)
      end
    end

    context 'when user is the author' do
      it 'does not create vote' do
        votable.update(user: voter)
        expect { voter.upvote votable }.to_not change(votable.votes, :count)
      end
    end
  end

  describe '#has_voted_for?' do
    it 'returns true if already voted' do
      voter.upvote votable
      expect(voter.has_voted_for?(votable)).to be_truthy
    end

    it 'returns false otherwise' do
      expect(voter.has_voted_for?(votable)).to be_falsey
    end
  end

  describe '#recall_vote' do
    it 'destroys votes for give obj' do
      voter.upvote votable
      voter.recall_vote(votable)
      expect(voter.votes.where(votable: votable).any?).to be_falsey
    end
  end
end
