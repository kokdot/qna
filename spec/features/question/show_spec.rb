require 'rails_helper'

feature 'User can see list of answers for question', %q{
In order to get answer from a community
As an authenticated user
I'd like to be able to see list of answers for questions
} do

  given!(:user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:answers) { create_list(:answer, 5, question: question) }

  background do
    sign_in(user) 
    visit questions_path
    click_on question.body
  end

  scenario 'see list of answers for questions' do
    answers.each do |answer|
      expect(page).to have_content(answer.body)
    end
  end
end
