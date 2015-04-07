FactoryGirl.define do  
  factory :answer do
    sequence(:body) { |n| "Answer_##{n}" }
  end
end
