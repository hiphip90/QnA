require 'rails_helper'

feature 'Sign in process with oauth', %q{
  In order to be able to ask questions
  As a user
  I must be able to sign in via other services
} do

  let!(:user) { create(:user) }

  before do
    visit new_user_session_path
  end

  describe 'signin via twitter' do
    before do
      OmniAuth.config.mock_auth[:twitter] = nil
      mock_auth_hash(:twitter)
      click_on 'Sign in with Twitter'
    end

    scenario 'user signs in from twitter' do
      expect(page).to have_content 'Provide email'
      fill_in 'Email', with: 'correct@email.com'
      click_on 'Save'
      expect(page).to have_content 'Your email was updated. We have sent you a confirmation email.'
    end

    scenario 'user signs in from twitter and doesnt fill email' do
      fill_in 'Email', with: ''
      click_on 'Save'
      expect(page).to have_content "Email can't be blank"
    end

    scenario 'user signs in from twitter and uses taken email' do
      fill_in 'Email', with: user.email
      click_on 'Save'
      expect(page).to have_content 'Email has already been taken'
    end
  end

  describe 'signin via facebook' do
    scenario 'user signs in from facebook' do
      mock_auth_hash(:facebook)
      click_on 'Sign in with Facebook'
      expect(page).to have_content 'Successfully authenticated from Facebook account.'
    end
  end
end