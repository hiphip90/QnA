require_relative '../feature_js_config'

feature 'Question delete process', %q{
  In order to remove duplication
  As a user
  I must be able to delete my questions
} do

  let(:user) { create(:user, :author) }
  let(:question) { user.questions.last } 
  let(:other_user) { create(:user) }

  scenario 'User deletes his question' do
    sign_in_as(user)
    visit question_path(question)
    click_on 'Delete question'

    expect(current_path).to eq questions_path
    expect(page).to have_content "You've successfully deleted a question!"
  end

  scenario 'User tries to delete question from another user' do
    sign_in_as(user)
    question.update(user: other_user)
    visit question_path(question)

    expect(page).to_not have_link 'Delete question'
  end

  scenario 'Non-authenticated user tries to delete question' do
    visit question_path(question)

    expect(page).to_not have_link 'Delete question'
  end

  scenario 'User deletes his question from index', js: true do
    sign_in_as(user)
    visit root_path
    
    click_on 'Delete question'

    expect(page).to_not have_content question.title
  end
end