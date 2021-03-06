FactoryGirl.define do  
  factory :question do
    sequence(:title) { |n| "My question #{n}" }
    body "Ultimate Question of Life, Universe and Everything"
    user

    trait :invalid do 
      title nil
      body nil
    end

    trait :with_answer do
      after(:create) { |question| create(:answer, question: question) }
    end

    trait :with_answers do
      after(:create) { |question| create_list(:answer, 5, question: question) }
    end
  end
end
