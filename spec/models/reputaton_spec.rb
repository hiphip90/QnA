require "rails_helper"

RSpec.describe Reputation, type: :model do
  
  describe ".update" do
    let(:user) { create(:user) }
    it 'changes users reputation' do
      expect{ Reputation.update(user, 3) }.to change(user, :reputation).by 3
    end
  end
end
