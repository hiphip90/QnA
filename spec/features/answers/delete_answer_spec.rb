require_relative '../feature_js_config'

feature 'Delete answer process', %q{
  In order to delete bad answer
  As a user
  I must be able to delete my answers
} do

  background do
    @user = create(:user, :author)
    @another_user = create(:user)
    @question = @user.questions.last
    @answer = @question.answers.create(body: 'smth smth answer', user: @user)
    sign_in_as(@user)
  end

  scenario 'User deletes his answer', js: true do
    @answer.update_attributes(user: @user)

    visit question_path(@question)
    click_on 'Delete answer'
    
    expect(page).to_not have_content 'smth smth answer'
  end

  scenario "User tries to delete someone else's answer" do
    @answer.update_attributes(user: @another_user)

    visit question_path(@question)
    expect(page).to_not have_content 'Delete answer'
  end

  scenario 'Non-authenticated user tries to delete answer' do
    @answer.update_attributes(user: @user)

    visit root_path
    click_on 'Sign Out'
    visit question_path(@question)
    expect(page).to_not have_content 'Delete answer'
  end
end
