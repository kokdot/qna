FactoryBot.define do
  factory :vote do
    user
    votes { 1 }
  end

  trait :against do
    votes { -1 }
  end
end
