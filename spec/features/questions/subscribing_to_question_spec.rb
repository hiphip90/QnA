require_relative '../feature_js_config'

feature 'Subscription to question', %q{
  In order to receive notifications
  As an authenticated user
  I must be able to subscribe to question
} do

  let(:user) { create(:user, :author) }
  let(:question) { user.questions.last }

  scenario 'authenticated user subscribes to question', js: true do
    sign_in_as(user)
    visit question_path(question)
    
    click_link 'Subscribe to new answers'

    expect(page).to have_content('Successfully subscribed!')
  end

  scenario 'subscribed user tries to subscribe again', js: true do
    sign_in_as(user)
    visit question_path(question)
    
    click_link 'Subscribe to new answers'

    expect(page).to have_content('Successfully subscribed')

    visit question_path(question)

    expect(page).to_not have_link('Subscribe to new answers')
  end

  scenario 'unauthenticated user tries to subscribe', js: true do
    visit question_path(question)

    expect(page).to_not have_link('Subscribe to new answers')
  end

end