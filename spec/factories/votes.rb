FactoryBot.define do
  factory :vote do
    user
    value { 1 }
  end

  trait :against do
    value { -1 }
  end
end
