include ActionDispatch::TestProcess

FactoryGirl.define do  
  factory :attachment do
    file { fixture_file_upload(File.join(Rails.root, 'spec', 'spec_helper.rb')) }
  end
end