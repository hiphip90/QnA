FactoryGirl.define do
  factory :vote do
    user { create(:user) }
    votable { create(:answer) }

    trait :upvote do
      value 1
    end

    trait :downvote do
      value -1
    end
  end
end
