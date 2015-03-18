require 'rails_helper'

feature 'Checking questions list', %q{
  In order to check if question has already been asked
  As a user
  I must be able to see questions list
} do

  scenario 'User requests questions list' do
    question_list = create_list(:question, 3)

    visit root_path
    click_on 'Questions'
    
    question_list.each do |question|
      expect(page).to have_link question.title
    end
  end
end
