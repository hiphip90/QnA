require_relative '../feature_js_config'

feature 'Question edit process', %q{
  In order to improve question
  As an author of a question
  I must be able to edit my questions
} do

  let(:user) { create(:user, :author) }
  let(:question) { user.questions.last }
  let(:another_user) { create(:user) }

  scenario 'author edits his question', js: true do
    sign_in_as(user)
    visit question_path(question)
    old_content = question.body
    
    click_link 'Edit question'
    fill_in 'Question', with: 'Edited question'
    click_on 'Save changes'

    expect(page).to have_content('Edited question')
    expect(page).to_not have_selector('textarea#question_body')
    expect(page).to_not have_content(old_content)
  end

  scenario 'user tries to edit other users question' do
    question.update(user: another_user)
    sign_in_as(user)
    visit question_path(question)

    expect(page).to_not have_content('Edit question')
  end

  scenario 'Non-authenticated user tries to edit question' do
    visit question_path(question)

    expect(page).to_not have_content('Edit question_path')
  end

end