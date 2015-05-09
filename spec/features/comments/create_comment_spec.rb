require_relative '../feature_js_config'

feature 'Create comment', %q{
  In order to clarify question or answer
  As an authenticated user
  I must be able to create comments
} do

  given(:user) { create(:user, :author) }
  given(:question) { user.questions.last }
  given(:answer) { create(:answer, question: question) }

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
  end
end
