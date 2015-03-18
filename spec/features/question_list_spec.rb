require 'rails_helper'

feature 'Checking questions list', %q{
  In order to check if question has already been asked
  As a user
  I must be able to see questions list
} do

  given!(:question_list) { create_list(:question, 3) }

  scenario 'User requests questions list' do
    visit root_path
    click_on 'Questions'
    
    question_list.each do |question|
      expect(page).to have_link question.title
    end
  end
end
