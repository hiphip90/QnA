require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_db_column(:name).of_type(:string) }
  it { should have_db_column(:email).of_type(:string) }
  it { should validate_presence_of(:email) }
  it { should validate_uniqueness_of(:email).case_insensitive }
  it { should validate_length_of(:email).is_at_most(150) }
  it { should allow_value('user@example.com', 'USER@foo.COM', 'A_US-ER@foo.bar.org',
                         'first.last@foo.jp', 'alice+bob@baz.cn').for(:email) }
  it { should_not allow_value('user@example,com', 'user_at_foo.org', 'user.name@example.',
                           'foo@bar_baz.com', 'foo@bar+baz.com', 'foo@bar..com').for(:email) }
  
  it 'saves email in all downcase' do
    user = create(:user, email: "EMilY@GmaiL.COM")
    user.reload
    expect(user.email).to eq "emily@gmail.com"
  end

  it { should have_many(:questions).dependent(:destroy) }
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:votes) }
  it { should have_many(:comments).dependent(:destroy) }
  it { should have_many(:authorizations).dependent(:destroy) }

  describe '.find_for_oauth' do
    let!(:user) { create(:user) }
    let(:auth) { OmniAuth::AuthHash.new(provider:'facebook', uid: '123456') }

    context 'user already has authorization' do
      it 'returns user' do
        user.authorizations.create(provider: 'facebook', uid: '123456')
        expect(User.find_for_oauth(auth)).to eq user
      end
    end

    context 'user does not have authorization' do
      context 'user exists' do
        let(:auth) { OmniAuth::AuthHash.new(provider:'facebook', uid: '123456', info: { email: user.email }) }

        it 'does not create user' do
          expect{ User.find_for_oauth(auth) }.to_not change(User, :count)
        end

        it 'creates corresponding authorization' do
          expect{ User.find_for_oauth(auth) }.to change(user.authorizations, :count).by 1
        end

        it 'creates correct authorization' do
          user = User.find_for_oauth(auth)
          authorization = user.authorizations.last

          expect(authorization.provider).to eq auth.provider
          expect(authorization.uid).to eq auth.uid
        end

        it 'returns user' do
          expect(User.find_for_oauth(auth)).to eq user
        end
      end

      context 'user does not exist' do
        context 'when auth contains email' do
          let(:auth) { OmniAuth::AuthHash.new(provider:'facebook', uid: '123456', info: { email: 'new@user.com' }) }
        
          it 'creates user' do
            expect{ User.find_for_oauth(auth) }.to change(User, :count).by 1
          end

          it 'returns user' do
            expect(User.find_for_oauth(auth)).to be_a User
          end

          it 'fills in email' do
            user = User.find_for_oauth(auth)
            expect(user.email).to eq auth.info[:email]
          end

          it 'creates authorization for user' do
            user = User.find_for_oauth(auth)
            expect(user.authorizations).to_not be_empty
          end

          it 'assigns provider and uid' do
            user = User.find_for_oauth(auth)
            authorization = user.authorizations.last

            expect(authorization.provider).to eq auth.provider
            expect(authorization.uid).to eq auth.uid
          end
        end

        context 'when auth does not contain email' do
          let(:auth) { OmniAuth::AuthHash.new(provider:'twitter', uid: '123456', info: {}) }
        
          it 'creates user' do
            expect{ User.find_for_oauth(auth) }.to change(User, :count).by 1
          end

          it 'returns user' do
            expect(User.find_for_oauth(auth)).to be_a User
          end

          it 'fills in email' do
            user = User.find_for_oauth(auth)
            expect(user.email).to eq User::EMAIL_PLACEHOLDER
          end

          it 'creates authorization for user' do
            user = User.find_for_oauth(auth)
            expect(user.authorizations).to_not be_empty
          end

          it 'assigns provider and uid' do
            user = User.find_for_oauth(auth)
            authorization = user.authorizations.last

            expect(authorization.provider).to eq auth.provider
            expect(authorization.uid).to eq auth.uid
          end
        end
      end
    end
  end
end
