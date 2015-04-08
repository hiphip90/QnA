require 'rails_helper'

RSpec.describe Question, type: :model do
  it { should have_db_column(:title).of_type(:string) }
  it { should have_db_column(:body).of_type(:text) }
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:body) }
  it { should validate_length_of(:title).is_at_most(150) }

  it { should have_many(:answers).dependent(:destroy) }
  it { should belong_to(:user) }

  describe '#has_accepted_answer?' do
    let(:question) { create(:question, :with_answers) }
    let(:answer) { question.answers.last }

    context 'when there is an accepted answer' do
      it 'returns true' do
        answer.update_attributes(accepted: true)
        expect(question.has_accepted_answer?).to be_truthy
      end
    end

    context 'when there is no accepted answer' do
      it 'returns false' do
        expect(question.has_accepted_answer?).to be_falsey
      end
    end
  end
end
