require_relative '../feature_js_config'

feature 'Accepted answer', %q{
  In order to mark most relevant answer
  As an author of a question
  I must be able to mark answer as accepted
} do
  
  given(:user) { create(:user, :author) }
  given(:question) { user.questions.last }
  given!(:answer) { create_list(:answer, 5, question: question, user: user)[-1] }

  scenario 'Author of the question accepts answer', js: true do 
    sign_in_as(user)
    visit question_path(user.questions.last)

    expect(page).to have_selector("li:last-child span", text: answer.body)
    within("#answer_#{answer.id}") do
      click_on 'Accept answer'
      expect(page).to_not have_link("Accept_answer")
    end
    expect(page).to_not have_selector("li:last-child span", text: answer.body)
    expect(page).to have_selector("li:first-child span", text: answer.body)
  end

end
