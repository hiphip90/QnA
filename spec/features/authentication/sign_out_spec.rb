require 'rails_helper'

feature 'Sign out process', %q{
  In order to end session
  As a user
  I must be able to sign out
} do
  
  scenario 'User signs out' do
    user = create(:user)

    sign_in_as(user)
    click_on 'Sign Out'

    expect(current_path).to eq root_path
    expect(page).to have_content 'Signed out successfully.'
  end
end