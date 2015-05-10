require_relative '../feature_js_config'

feature 'Checking questions list', %q{
  In order to check if question has already been asked
  As a user
  I must be able to see questions list
} do

  let(:user) { create(:user) }

  background do
    sign_in_as(user)
  end

  scenario 'User requests questions list' do
    question_list = create_list(:question, 3)

    visit root_path
    click_on 'Questions'
    
    question_list.each do |question|
      expect(page).to have_link question.title
    end
  end

  scenario 'List updates without reload', js: true do
    other_user_session = Capybara::Session.new(:webkit, QnA::Application)
    other_user_session.visit root_path

    visit new_question_path
    fill_in 'Title', with: 'Ultimate question'
    fill_in 'Body', with: 'Of life, universe and everything'
    click_on 'Create question'

    sleep(2)

    expect(other_user_session).to have_content 'Ultimate question'
  end
end
