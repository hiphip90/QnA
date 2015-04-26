require_relative '../feature_js_config'

feature 'Add files to question', %q{
  In order to illustrate my question
  As an author of a question
  I must be able to attach files
} do

  given(:user) { create(:user, :author) }

  background do
    sign_in_as(user)
  end

  scenario 'add files on creation', js: true do
    visit new_question_path

    fill_in 'Title', with: 'Question1'
    fill_in 'Body', with: 'Question with files'
    attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
    click_link 'Moar files'
    within '.nested-fields:not(:first-child)' do
      attach_file 'File', "#{Rails.root}/spec/rails_helper.rb"
    end

    click_on 'Create question'
    expect(page).to have_link 'spec_helper.rb'
    expect(page).to have_link 'rails_helper.rb'
  end
end
