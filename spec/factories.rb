FactoryGirl.define do  
  factory :user do
    name "Emily"
    email "emily@gmail.com"
  end
  
  factory :question do
    title "My question"
    body "Ultimate Question of Life, Universe and Everything"
  end

  factory :answer do
    body "42"
  end
end
