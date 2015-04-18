require_relative '../feature_js_config'

feature 'Add files to answer', %q{
  In order to illustrate my answer
  As an author of an answer
  I must be able to attach files
} do

  given(:user) { create(:user) }
  given(:question) { create(:question) }
 
  background do
    sign_in_as(user)
    visit question_path(question)
  end

  scenario 'add files on creation', js: true do
    fill_in 'Body', with: 'Answer with files'
    attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
    click_link 'Moar files'
    within 'p .fields' do
      attach_file 'File', "#{Rails.root}/spec/rails_helper.rb"
    end

    click_on 'Post answer'

    within('.answers') do
      expect(page).to have_link 'spec_helper.rb', href: '/uploads/attachment/file/1/spec_helper.rb'
      expect(page).to have_link 'rails_helper.rb', href: '/uploads/attachment/file/2/rails_helper.rb'
    end
  end
end
