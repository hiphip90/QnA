require_relative 'feature_js_config'

feature 'Answer editing', %q{
  In order to improve Answer
  As an author of Answer
  I must be able to edit my answer
} do
  
  given(:user) { create(:user, :author) }
  given!(:answer) { create(:answer, question: user.questions.last, user: user) }
  given(:other_user) { create(:user) }

  scenario 'Authenticated user edits answer', js: true do
    sign_in_as(user)
    visit question_path(user.questions.last)

    within '.answers-block' do
      click_on 'Edit answer'
      fill_in 'Edit answer', with: 'something something answer'
      click_on 'Save'
    end

    expect(page).to_not have_content(answer.body)
    expect(page).to have_content('something something answer')
    within('.answers-block') do
      expect(page).to_not have_selector('textarea')
    end
  end

  scenario 'Unauthenticated user tries to edit answer' do
    visit question_path(user.questions.last)

    expect(page).to_not have_link 'Edit answer'
  end

  scenario "Authenticated user tries to edit other user's answer" do
    sign_in_as(user)
    answer.update_attributes(user: other_user)
    visit question_path(user.questions.last)

    expect(page).to_not have_link 'Edit answer'
  end
end
