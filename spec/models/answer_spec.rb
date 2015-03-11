require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should have_db_column(:body).of_type(:text) }
  it { should validate_presence_of(:body) }
end
