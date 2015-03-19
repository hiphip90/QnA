require 'rails_helper'

feature 'Question delete process', %q{
  In order to remove duplication
  As a user
  I must be able to delete my questions
} do

  background do
    @user = create(:user, :author)
    @another_user  = create(:user, :author)
    sign_in_as(@user)
  end

  scenario 'User deletes his question' do
    visit question_path(@user.questions.last)
    click_on 'Delete question'

    expect(current_path).to eq root_path
    expect(page).to have_content "You've successfully deleted a question!"
  end

  scenario 'User tries to delete question from another user' do
    visit question_path(@another_user.questions.last)

    expect(page).to_not have_link 'Delete question'
  end

  scenario 'Non-authenticated user tries to delete question' do
    visit root_path
    click_on 'Sign Out'
    visit question_path(@user.questions.last)

    expect(page).to_not have_link 'Delete question'
  end
end