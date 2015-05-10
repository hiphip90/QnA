require_relative '../feature_js_config'

feature 'Create comment', %q{
  In order to clarify question or answer
  As an authenticated user
  I must be able to create comments
} do

  given(:user) { create(:user, :author) }
  given(:question) { user.questions.last }
  given!(:answer) { create(:answer, question: question) }

  background do
    sign_in_as(user)
  end

  scenario 'add comment to question', js: true do
    other_user_session = Capybara::Session.new(:webkit, QnA::Application)
    other_user_session.visit question_path(user.questions.last)
    visit question_path(question)

    within ".question" do
      click_link 'Add comment'
      fill_in 'Comment', with: "Commentin'"
      click_on 'Post'

      expect(page).to have_content "Commentin'"
      expect(other_user_session).to have_content "Commentin'"
    end

    within ".answers-block" do
      expect(page).to_not have_content "Commentin'"
    end
  end

  scenario 'add comment to answer', js: true do
    other_user_session = Capybara::Session.new(:webkit, QnA::Application)
    other_user_session.visit question_path(user.questions.last)
    visit question_path(question)

    within ".answers-block" do
      click_link 'Add comment'
      fill_in 'Comment', with: "Commentin'"
      click_on 'Post'

      expect(page).to have_content "Commentin'"
      expect(other_user_session).to have_content "Commentin'"
    end

    within ".question" do
      expect(page).to_not have_content "Commentin'"
    end
  end

  scenario 'user is not logged in' do
    visit root_path
    click_on 'Sign Out'
    
    visit question_path(question)
    expect(page).to_not have_link "Add comment"
  end
end
