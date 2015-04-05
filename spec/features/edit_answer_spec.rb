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
      fill_in 'answer_body', with: 'something something answer'
      click_on 'Save'

      expect(page).to_not have_selector('textarea')
      expect(page).to_not have_content(answer.body)
      expect(page).to have_content('something something answer')
    end
  end

  scenario 'Authenticated user edits freshly created answer', js: true do
    sign_in_as(user)
    answer.destroy
    visit question_path(user.questions.last)

    fill_in 'Body', with: answer.body
    click_on 'Post answer'

    within '.answers-block' do
      expect(page).to have_content(answer.body)

      click_on 'Edit answer'
      fill_in 'answer_body', with: 'something something answer'
      click_on 'Save'

      expect(page).to_not have_selector('textarea')
      expect(page).to_not have_content(answer.body)
      expect(page).to have_content('something something answer')
    end
  end

  scenario 'Authenticated user discards changes', js: true do
    sign_in_as(user)
    visit question_path(user.questions.last)

    within '.answers-block' do
      click_on 'Edit answer'
      fill_in 'answer_body', with: 'something something answer'
      click_on 'Discard'

      expect(page).to_not have_selector('textarea')
      expect(page).to_not have_content("something something answer")
      expect(page).to have_content(answer.body)
    end
  end

  scenario 'Authenticated user edits answer with invalid info', js: true do
    sign_in_as(user)
    visit question_path(user.questions.last)

    within '.answers-block' do
      click_on 'Edit answer'
      fill_in 'answer_body', with: ''
      click_on 'Save'

      expect(page).to have_selector('textarea')
      expect(page).to have_content("Body can't be blank")
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
