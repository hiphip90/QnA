require_relative '../feature_js_config'

feature 'Voting for question', %q{
  In order to express my opinion
  As an authenticated user
  I must be able to vote for question
} do

  let(:user) { create(:user) }
  let(:question) { create(:question) }
  
  background do
    sign_in_as(user)
  end
  
  scenario 'User upvotes question', js:true do
    visit question_path(question)
    click_link 'Upvote'

    within ('.rating') do
      expect(page).to have_content '1'
    end
  end

  scenario 'User downvotes answer', js:true do
    visit question_path(question)
    click_link 'Downvote'
      
    within ('.rating') do
      expect(page).to have_content '-1'
    end
  end

  scenario 'User can vote only once', js:true do
    visit question_path(question)
    click_link 'Downvote'

    expect(page).to_not have_content('Upvote')
    expect(page).to_not have_content('Downvote')
  end

  scenario 'User cannot vote for his own answer', js:true do
    question.update(user: user)
    visit question_path(question)

    expect(page).to_not have_content('Upvote')
    expect(page).to_not have_content('Downvote')
  end

  scenario 'User recalls his vote', js:true do
    visit question_path(question)
    click_link 'Downvote'

    within ('.rating') do
      expect(page).to have_content '-1'
    end

    click_link 'Recall vote'

    within ('.rating') do
      expect(page).to have_content '0'
    end

    expect(page).to have_content('Upvote')
    expect(page).to have_content('Downvote')
  end
end
