FactoryGirl.define do
  factory :vote do
    trait :upvote do
      value 1
    end

    trait :downvote do
      value -1
    end
  end
end
