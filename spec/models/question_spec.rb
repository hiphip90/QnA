require 'rails_helper'

RSpec.describe Question, type: :model do
  it { should have_db_column(:title).of_type(:string) }
  it { should have_db_column(:body).of_type(:text) }
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:body) }
  it { should validate_length_of(:title).is_at_most(150) }

  it { should have_many(:answers).dependent(:destroy) }
  it { should belong_to(:user) }

  describe '#accept' do
    let(:question) { create(:question, :with_answers) }
    let(:other_question) { create(:question) }
    let(:answer) { question.answers.last }

    context 'when answer belongs to given question' do
      it "sets answer's accepted attr to true" do
        question.accept(answer)
        expect(answer.accepted?).to be_truthy
      end

      it "returns true" do
        expect(question.accept(answer)).to be_truthy
      end

      context 'when question already has accepted answer' do
        it 'de-accepts previously accepted answer' do
          accepted_earlier = question.answers.first
          accepted_earlier.update(accepted: true)

          question.accept(answer)
          accepted_earlier.reload
          expect(accepted_earlier.accepted?).to be_falsey
        end
      end
    end

    context 'when answers belongs to another question' do
      before { answer.update(question: other_question) }

      it 'does not set accepted to true' do
        question.accept(answer)
        answer.reload
        expect(answer.accepted?).to be_falsey
      end

      it 'returns false' do
        expect(question.accept(answer)).to be_falsey
      end
    end 
  end
end
