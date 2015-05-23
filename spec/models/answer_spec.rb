require 'rails_helper'
require_relative 'shared_examples/votable'
require_relative 'shared_examples/commentable'

RSpec.describe Answer, type: :model do
  it { should have_db_column(:body).of_type(:text) }
  it { should validate_presence_of(:body) }
  it { should belong_to(:question) }
  it { should belong_to(:user) }
  it { should have_many(:attachments).dependent(:destroy) }

  it { should accept_nested_attributes_for :attachments }

  it_behaves_like 'votable'
  it_behaves_like 'commentable'

  it 'calls Reputation.update after create/destroy' do
    expect(Reputation).to receive(:update).exactly(2).times

    answer = create(:answer)
    answer.destroy
  end

  describe '#accept' do
    let(:question) { create(:question, :with_answers) }
    let(:answer) { question.answers.last }

    it "sets answer's accepted attr to true" do
      answer.accept
      expect(answer.accepted?).to be_truthy
    end

    it "returns true" do
      expect(answer.accept).to be_truthy
    end

    context 'when question already has accepted answer' do
      it 'de-accepts previously accepted answer' do
        accepted_earlier = question.answers.first
        accepted_earlier.update(accepted: true)

        answer.accept
        accepted_earlier.reload
        expect(accepted_earlier.accepted?).to be_falsey
      end
    end
  end

  describe '#recall_accept' do
    let(:answer) { create(:answer, accepted: true) }

    it "sets answer's accepted attr to true" do
      answer.recall_accept
      expect(answer.accepted?).to be_falsey
    end
  end

  describe '#first' do
    let(:question) { create(:question) }
    let!(:first_answer) { create(:answer, question: question) }
    let!(:last_answer) { create(:answer, question: question) }

    it 'returns true if answer is first' do
      expect(first_answer.first?).to be_truthy
    end

    it 'returns false if answer is not first' do
      expect(last_answer.first?).to be_falsey
    end
  end

  describe '#to_own_question?' do
    let(:user) { create(:user) }
    let(:question) { create(:question, user: user) }
    let(:own_answer) { create(:answer, question: question, user: user) }
    let(:others_answer) { create(:answer, question: question) }

    it 'returns true if answer is to own question' do
      expect(own_answer.to_own_question?).to be_truthy
    end

    it 'returns false if answer is to someone elses question' do
      expect(others_answer.to_own_question?).to be_falsey
    end
  end
end
