require_relative '../feature_js_config'

feature 'Accepted answer', %q{
  In order to mark most relevant answer
  As an author of a question
  I must be able to mark answer as accepted
} do
  
  given(:user) { create(:user, :author) }
  given(:other_user) { create(:user) }
  given(:question) { user.questions.last }
  given!(:answer) { create_list(:answer, 5, question: question, user: user)[-1] }

  scenario 'Author of the question accepts answer', js: true do 
    sign_in_as(user)
    visit question_path(question)

    expect(page).to have_selector("li:last-child span", text: answer.body)
    within("#answer_#{answer.id}") do
      click_on 'Accept answer'
      expect(page).to_not have_link("Accept answer")
    end
    expect(page).to_not have_selector("li:last-child span", text: answer.body)
    expect(page).to have_selector("li:first-child span", text: answer.body)

    # accepted answer should remain first on reload
    visit current_path
    expect(page).to have_selector("li:first-child span", text: answer.body)
  end

  scenario 'Non-author tries to accept answer' do 
    sign_in_as(user)
    question.update(user: other_user)
    visit question_path(question)

    expect(page).to_not have_link("Accept answer")
  end

  scenario 'Unauthenticated user tries to accept answer' do
    visit question_path(question)

    expect(page).to_not have_link("Accept answer")
  end
end
