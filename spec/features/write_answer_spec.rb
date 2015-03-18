require 'rails_helper'

feature 'Writing answer', %q{
  In order to help in solving the problem
  As a user
  I must be able to write answer
} do

  scenario 'User writes answer' do
    question = create(:question)

    visit question_path(question)
    fill_in 'Body', with: "Do a barrell roll"
    click_on 'Post answer'

    expect(page).to have_content "Do a barrell roll"
  end
end
