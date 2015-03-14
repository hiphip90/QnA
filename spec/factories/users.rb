FactoryGirl.define do  
  factory :user do
    name "Emily"
    sequence(:email) { |n| "emily#{n}@gmail.com" }
    trait :invalid do
      name nil
      email nil
    end
  end
end
