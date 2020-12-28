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
		
		trait :special do
			body { 'MyText' }
		end
		
		trait :with_comments do
			after(:create) do |answer|
				create_list(:comment, 3, commentable: answer)
			end
		end

    trait :with_file do
			files { [fixture_file_upload(Rails.root.join('spec', 'rails_helper.rb'), 'text/rb'), 
				fixture_file_upload(Rails.root.join('spec', 'spec_helper.rb'), 'text/rb')] }
    end
    
    trait :with_link do
      after(:create) do |answer|
        create(:link, linkable: answer)
      end
    end

    trait :with_links do
      after(:create) do |answer|
        create_list(:link, 3, linkable: answer)
      end
    end
  end
end
