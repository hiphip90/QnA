require 'rails_helper'

feature 'Delete answer process', %q{
  In order to delete bad answer
  As a user
  I must be able to delete my answers
} do

  background do
    @user = create(:user, :author)
    @another_user = create(:user)
    @question = @user.questions.last
    sign_in_as(@user)
  end

  scenario 'User deletes his answer' do
    answer = @user.answers.build(body: 'smth smth answer')
    answer.question = @question
    answer.save

    visit question_path(@question)
    click_on 'Delete answer'

    expect(current_path).to eq question_path(@question)
    expect(page).to_not have_content 'smth smth answer'
  end

  scenario "User tries to delete someone else's answer" do
    answer = @another_user.answers.build(body: 'smth smth answer')
    answer.question = @question
    answer.save

    visit question_path(@question)
    expect(page).to_not have_content 'Delete answer'
  end

  scenario 'Non-authenticated user tries to delete answer' do
    answer = @user.answers.build(body: 'smth smth answer')
    answer.question = @question
    answer.save

    visit root_path
    click_on 'Sign Out'
    visit question_path(@question)
    expect(page).to_not have_content 'Delete answer'
  end
end
