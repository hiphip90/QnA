FactoryGirl.define do  
  factory :answer do
    sequence(:body) { |n| "Answer_##{n}" }
    accepted false
    user { create(:user) }
    question { create(:question) }
  end
end
