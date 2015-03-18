require 'rails_helper'

feature 'Sign out process', %q{
  In order to end session
  As a user
  I must be able to sign out
} do
  
  scenario 'User signs out' do
    user = create(:user)

    visit root_path
    click_on 'Sign In'
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_button 'Log in'
    click_on 'Sign Out'

    expect(current_path).to eq root_path
    expect(page).to have_content 'Signed out successfully.'
  end
end