require_relative 'sphinx_config'

feature 'Search', %q{
  In order to find content
  As a User
  I must be able to use search
} do

  scenario 'User searches for questions' do
    create(:question, title: 'kewl')
    index

    visit root_path
    fill_in 'search_q', with: 'kewl'
    page.select 'Questions', from: 'search_scope'
    click_on 'Find'

    within '.search-results' do
      expect(page).to have_content 'kewl'
    end
  end

  scenario 'User searches for answers' do
    create(:answer, body: 'Search term')
    index

    visit root_path
    fill_in 'search_q', with: 'Search term'
    page.select 'Answers', from: 'search_scope'
    click_on 'Find'

    within '.search-results' do
      expect(page).to have_content 'Search term'
    end
  end

  scenario 'User searches for comments' do
    create(:comment, body: 'Search term')
    index

    visit root_path
    fill_in 'search_q', with: 'Search term'
    page.select 'Comments', from: 'search_scope'
    click_on 'Find'

    within '.search-results' do
      expect(page).to have_content 'Search term'
    end
  end

  scenario 'User searches for comments' do
    create(:user, name: 'Search term')
    index

    visit root_path
    fill_in 'search_q', with: 'Search term'
    page.select 'Users', from: 'search_scope'
    click_on 'Find'

    within '.search-results' do
      expect(page).to have_content 'Search term'
    end
  end
end
