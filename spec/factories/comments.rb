FactoryBot.define do
  factory :comment do
    body {"MyCommentText"}
    association :commentable, factory: [:question, :answer]

    trait :invalid do
      body {''}
    end
  end
end
