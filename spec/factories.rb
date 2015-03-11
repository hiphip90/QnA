FactoryGirl.define do  
  factory :question do
    title "My question"
    body "Ultimate Question of Life, Universe and Everything"
  end

  factory :answer do
    body "42"
  end
end
