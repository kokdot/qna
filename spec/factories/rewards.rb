FactoryBot.define do
  factory :reward do
    question
    name { "MyReward" }
    file { fixture_file_upload(Rails.root.join('public', 'fantasy.jpg'), 'image/jpg') }
  end
end
