FactoryGirl.define do  
  factory :user do
    name "Emily"
    sequence(:email) { |n| "emily#{n}@gmail.com" }
    password "password123"
    password_confirmation "password123"
    trait :invalid do
      name nil
      email nil
    end
  end
end
