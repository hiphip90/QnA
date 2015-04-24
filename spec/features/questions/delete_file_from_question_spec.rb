require_relative '../feature_js_config'

feature 'Delete files from question', %q{
  In order to improve my question
  As an author of a question
  I must be able to delete files from it
} do

  given(:user) { create(:user, :author) }

  background do
    sign_in_as(user)
  end

  scenario 'delete file', js: true do
    visit new_question_path

    fill_in 'Title', with: 'Question1'
    fill_in 'Body', with: 'Question with files'
    attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
    click_on 'Create question'
    expect(page).to have_link 'spec_helper.rb'
    click_on 'Edit question'

    within '.edit_question' do
      click_on 'Remove this attachment'
      click_on 'Save changes'
    end

    expect(page).to_not have_selector '.edit_question'
    expect(page).to_not have_link 'spec_helper.rb'
  end
end
