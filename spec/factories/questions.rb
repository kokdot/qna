FactoryBot.define do
  sequence :link do |n|
    "body_of_link#{n}"
  end
  factory :question do
    title { "MyString" }
    body { "MyText" }
    user

    trait :invalid do
      title { nil }
    end

    trait :with_link do
      after(:create) do |question|
        create(:link, linkable: question)
      end
    end

    trait :with_links do
      after(:create) do |question|
        create_list(:link, 3, linkable: question)
      end
    end
    
    trait :with_comments do
      after(:create) do |question|
        create_list(:comment, 3, commentable: question)
      end
    end

    trait :with_reward do
      after(:create) do |question|
        create(:reward, question: question)
      end
    end
    
    trait :with_file do
      files { [fixture_file_upload(Rails.root.join('spec', 'rails_helper.rb'), 'text/rb'), 
        fixture_file_upload(Rails.root.join('spec', 'spec_helper.rb'), 'text/rb')] }
    end
  end
end
