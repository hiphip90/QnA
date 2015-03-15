require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_db_column(:name).of_type(:string) }
  it { should have_db_column(:email).of_type(:string) }
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:email) }
  it { should validate_uniqueness_of(:email).case_insensitive }
  it { should validate_length_of(:email).is_at_most(150) }
  it { should validate_length_of(:name).is_at_most(150) }
  it { should allow_value('user@example.com', 'USER@foo.COM', 'A_US-ER@foo.bar.org',
                         'first.last@foo.jp', 'alice+bob@baz.cn').for(:email) }
  it { should_not allow_value('user@example,com', 'user_at_foo.org', 'user.name@example.',
                           'foo@bar_baz.com', 'foo@bar+baz.com', 'foo@bar..com').for(:email) }
  
  it 'saves email in all downcase' do
    user = create(:user, email: "EMilY@GmaiL.COM")
    user.reload
    expect(user.email).to eq "emily@gmail.com"
  end
end
