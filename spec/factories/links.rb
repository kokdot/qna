FactoryBot.define do
  factory :link do
    name { "My google" }
    url { "www.google.ru" }
    association :linkable, factory: [:question, :answer]
  end
end
