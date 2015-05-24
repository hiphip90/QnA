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

  describe 'it changes reputation on create' do
    let(:user) { create(:user) }
    let(:question) { create(:question) }

    context 'when neither first nor to own question' do
      before { create(:answer, question: question) }

      it 'by 1' do
        expect{ create(:answer, question: question, user: user) }.to change(user, :reputation).by 1
      end
    end

    context 'when first and to own question' do
      before { question.update(user: user) }

      it 'by 3' do
        expect{ create(:answer, question: question, user: user) }.to change(user, :reputation).by 3
      end
    end
  end

  describe 'it changes reputation on destroy' do
    let(:user) { create(:user) }
    let(:question) { create(:question) }

    context 'when neither first nor to own question' do
      before { create(:answer, question: question) }

      it 'by -1' do
        answer = create(:answer, question: question, user: user)
        expect{ answer.destroy }.to change(user, :reputation).by -1
      end
    end

    context 'when first and to own question' do
      before { question.update(user: user) }

      it 'by -3' do
        answer = create(:answer, question: question, user: user)
        expect{ answer.destroy }.to change(user, :reputation).by -3
      end
    end
  end

  describe 'it changes reputation on accept' do
    let(:user) { create(:user) }
    let!(:answer) { create(:answer, user: user) }

    it 'by 3' do
      expect{ answer.accept }.to change(user, :reputation).by 3
    end
  end

  describe 'it changes reputation on recall accept' do
    let(:user) { create(:user) }
    let!(:answer) { create(:answer, user: user) }

    it 'by -3' do
      expect{ answer.recall_accept }.to change(user, :reputation).by -3
    end
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

  describe 'mails on create' do
    let(:author) { create(:user) }
    let!(:subscriber) { create(:user) }
    let(:question) { create(:question, user: author) }

    before do
      ActionMailer::Base.deliveries = []
      subscriber.subscribe_to_new_answers(question)
      create(:answer ,question: question)
    end

    it 'to author of a question' do
      expect(ActionMailer::Base.deliveries.map { |mail| mail.to }).to include([author.email]) 
    end

    it 'to subscriber' do
      expect(ActionMailer::Base.deliveries.map { |mail| mail.to }).to include([subscriber.email]) 
    end
  end
end
