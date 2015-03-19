require 'rails_helper'

feature 'Creating question', %q{
  In order to solve a problem
  As a user
  I must be able to create questions
} do

  given(:user) { create(:user) }

  scenario 'Authenticated user creates a question' do
    sign_in_as(user)

    visit root_path
    click_on 'Ask question'
    fill_in 'Title', with: 'Ultimate question'
    fill_in 'Body', with: 'Of life, universe and everything'
    click_on 'Create question'

    expect(page).to have_content "You've successfully created a question!"
    expect(current_path).to eq(question_path(Question.last))
  end

  scenario 'Unauthenticated user creates a question' do
    
    visit root_path
    click_on 'Ask question'

    expect(current_path).to eq new_user_session_path
  end
end
