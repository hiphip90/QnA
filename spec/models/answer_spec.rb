require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should have_db_column(:body).of_type(:text) }
  it { should validate_presence_of(:body) }
  it { should belong_to(:question) }
  it { should belong_to(:user) }

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
end
