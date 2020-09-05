require 'rails_helper'

feature 'User can see list of questions', %q{
In order to get answer from a community
As an authenticated user
I'd like to be able to see list of questions
} do

  given!(:user) { create(:user) }
  given!(:questions) { create_list(:question, 5) }

  background { sign_in(user) }

  scenario 'see a list of questions' do
    visit questions_path
    questions.each do |question|
      expect(page).to have_content(question.title)
      expect(page).to have_content(question.body)
    end
  end
end