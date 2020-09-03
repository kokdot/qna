require 'rails_helper'

feature 'User can destroy your answer for question', %q{
In order to get answer for a community
As an authenticated user
I'd like to be able to destroy your  answer for question
} do

  given(:user) { create(:user) }
  given(:user_1) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user) }
  
  describe 'Authenticated user' do
    background do
        sign_in(user) 
        visit questions_path
        click_on question.body
    end
    scenario 'destroy answer for the question' do
      within('.answers') do 
      click_on 'Destroy'
      end

      expect(page).to_not have_content answer.body
    end
  end
end