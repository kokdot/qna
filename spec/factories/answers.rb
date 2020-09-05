FactoryBot.define do
  sequence :body do |n|
    "body_of_answer#{n}"
  end
  factory :answer do
    body
    question
    user

    trait :invalid do
      body { nil }
    end
  end
end
