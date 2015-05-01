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
  end

  describe '#downvote' do
    it 'creates new vote' do
      expect{ voter.downvote votable }.to change(votable.votes, :count).by 1
    end

    it 'assignes correct value to the vote' do
      voter.downvote votable
      expect(votable.votes.last.value).to eq(-1)
    end 
  end
end
