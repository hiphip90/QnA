require 'rails_helper'

feature 'Checking question page', %q{
  In order to see answers from community
  As a User
  I must be able to see question page
} do
  given!(:question) { create(:question, :with_answers) }

  scenario 'User requests question page' do
    visit root_path
    click_on question.title

    question.answers.each do |answer|
      expect(page).to have_content answer.body
    end
  end
end
