require 'rails_helper'
require_relative 'shared_examples/votable'
require_relative 'shared_examples/commentable'

RSpec.describe Question, type: :model do
  it { should have_db_column(:title).of_type(:string) }
  it { should have_db_column(:body).of_type(:text) }
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:body) }
  it { should validate_length_of(:title).is_at_most(150) }

  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:attachments).dependent(:destroy) }
  it { should belong_to(:user) }

  it { should accept_nested_attributes_for(:attachments) }

  it_behaves_like 'votable'
  it_behaves_like 'commentable'
end
