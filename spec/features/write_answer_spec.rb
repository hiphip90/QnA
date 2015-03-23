require 'rails_helper'

feature 'Writing answer', %q{
  In order to help in solving the problem
  As a user
  I must be able to write answer
} do

  given(:user) { create(:user, :author) }

  scenario 'Authenticated user writes answer' do
    sign_in_as(user)

    visit question_path(user.questions.last)
    fill_in 'Body', with: "Do a barrell roll"
    click_on 'Post answer'

    expect(page).to have_content "Do a barrell roll"
  end

  scenario 'Non-authenticated user writes answer' do
    visit question_path(user.questions.last)
    
    expect(page).to_not have_field 'Body'
    expect(page).to_not have_button 'Post answer'
  end
end
