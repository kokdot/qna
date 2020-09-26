FactoryBot.define do
  sequence :body do |n|
    "body_of_answer#{n}"
  end
  factory :answer do
    body
    question
    user
    best { false }

    trait :invalid do
      body { nil }
    end
    trait :with_file do
      files { fixture_file_upload(Rails.root.join('spec', 'rails_helper.rb'), 'text/rb') }
    end
  end
end
