FactoryBot.define do
  factory :comment do
    user
    body {"MyCommentText"}
    association :commentable, factory: [:question, :answer]

    trait :invalid do
      body {''}
    end
  end
end
