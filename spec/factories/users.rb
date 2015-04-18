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
    trait :author do
      after(:create) do |user|
        create(:question, user: user)
      end
    end
  end
end
