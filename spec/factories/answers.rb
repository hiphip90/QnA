FactoryGirl.define do  
  factory :answer do
    body "42"
    user
    question
  end
end
