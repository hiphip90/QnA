require_relative '../feature_js_config'

feature 'Delete files from answer', %q{
  In order to improve my answer
  As an author of an answer
  I must be able to delete attached files
} do

  given(:user) { create(:user) }
  given(:question) { create(:question) }
 
  background do
    sign_in_as(user)
    visit question_path(question)
  end

  scenario 'delete files from answer', js: true do
    fill_in 'Body', with: 'Answer with files'
    attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
    click_on 'Post answer'

    within('.answers') do
      click_on 'Edit answer'
      click_on 'Remove this attachment'
      click_on 'Save'

      expect(page).to_not have_selector '.edit_answer'
      expect(page).to_not have_link 'spec_helper.rb'
    end
  end
end
