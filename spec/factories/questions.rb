FactoryGirl.define do  
  factory :question do
    title "My question"
    body "Ultimate Question of Life, Universe and Everything"
    trait :invalid do 
      title nil
      body nil
    end
    user
  end
end
