FactoryGirl.define do  
  factory :user do
    name "Emily"
    sequence(:email) { |n| "emily#{n}@gmail.com" }
  end
end
