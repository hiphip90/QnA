require 'rails_helper'

feature 'Sign up process', %q{
  In order to be able to ask questions
  As a user
  I must be able to register
} do
  
  scenario 'User signs up' do
    user = build(:user)

    visit root_path
    click_on 'Sign Up'
    fill_in 'Name', with: user.name
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    fill_in 'Password confirmation', with: user.password
    click_button 'Sign up'

    expect(current_path).to eq root_path
    expect(page).to have_content "A message with a confirmation link has been sent to your email address"
  end
end
